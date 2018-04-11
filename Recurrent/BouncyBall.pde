public class BouncyBall {
  int pillar;
  float pos;
  int direction; //0 = up 1 = down 
  color ballColor;
  float speed;
  int frameLastMoved = 0;
  float dimPercentage = 0.9;
  float oscAngle = 0.0;
  float oscCenter = 0.0;

  ArrayList<Float> prevPos = new ArrayList<Float>();
  int tailSize = 10;

  public BouncyBall(int _pillar, float startPos, color _ballColor)
  {
    pillar = _pillar;
    pos = startPos;
    direction = 1;
    ballColor = _ballColor;
  }

  public BouncyBall(int _pillar, float startPos, int startDirection, color _ballColor)
  {
    pillar = _pillar;
    pos = startPos;
    direction = startDirection;
    ballColor = _ballColor;
  }

  public BouncyBall(int _pillar, float startPos, int startDirection, color _ballColor, float _speed)
  {
    pillar = _pillar;
    pos = startPos;
    direction = startDirection;
    ballColor = _ballColor;
    
    if(_speed <= 0.1)
      _speed = 0.1;
    speed = _speed;
    println(speed);
  }
  
  public void setDimPercentage(float _dim)
  {
     dimPercentage = _dim; 
  }
  
  public void setTailSize(int _tailSize)
  {
    tailSize = _tailSize;
  }

  public void drawToScreen()
  {
    noStroke();
    fill(ballColor);
    rect(pillar * (width/3), pos, (width/3), 1);

    color tailColor = ballColor;
    if (prevPos.size() > 0)
    {
      for (int i=prevPos.size()-1; i>=0; i--)
      {
        tailColor = dimColor(tailColor);
        fill(tailColor);
        rect(pillar * (width/3), prevPos.get(i), (width/3), 1);
      }
    }
  }

  public void switchDirection()
  {
    if (direction == 0)
    {
      direction = 1;
      pos++;
    } else if (direction == 1)
    {
      direction = 0;
      pos--;
    }
  }

  public void setSpeed(float _speed)
  {
    speed = _speed;
  }

  public void move()
  {
    if (direction == 1)
    {
      /*
      if (speed >= 1)
      {
        pos+=speed;
        frameLastMoved = frameCount;
      } else if (speed < 0)
      {
        if ((frameLastMoved - speed) < frameCount)
        {
          //println("lastMoved: " + frameLastMoved + " speed:" + speed + " frameCount:" + frameCount);
          pos++;
          frameLastMoved = frameCount;
        }
      }
      */
      
      pos += speed;

      if (pos >= 128)
        direction = 0;
    } else
    {
      /*
      if (speed >= 1)
      {
        pos-=speed;
        frameLastMoved = frameCount;
      } else if (speed < 0)
      {
        if ((frameLastMoved - speed) < frameCount)
        {
          pos--;
          frameLastMoved = frameCount;
        }
      }
      */
      
      pos -= speed;

      if (pos <= 0)
        direction = 1;
    }

    if (prevPos.size() >= tailSize)
      prevPos.remove(0);

    if(prevPos.size() == 0)
      prevPos.add(pos);
    else if (prevPos.get(prevPos.size()-1) != pos)
      prevPos.add(pos);
      
      //prevPos.add(pos);
  }

  public void move(float speed)
  {
    if (direction == 1)
    {
      pos += speed;
      if (pos >= 128)
        direction = 0;
    } else 
    {
      pos -= speed;
      if (pos <= 0)
        direction = 1;
    }
  }

  public void changeColor(color newColor)
  {
    ballColor = newColor;
  }

  public boolean checkIfSamePos(BouncyBall ball)
  {
    if (ball.pillar == this.pillar)
    {
      if (abs(ball.pos - this.pos) < 0.5)
        return true;
      else
        return false;
    } else
      return false;
  }

  public color dimColor(color oldColor)
  {
    float brightness = brightness(oldColor);
    float hue = hue(oldColor);
    float saturation = saturation(oldColor);

    brightness *= dimPercentage;

    return color(hue, saturation, brightness);
  }
  
  public void oscillate(float _oscCenter, float oscSpeed, float oscAmp)
  {
    _oscCenter += sin(oscAngle) * oscAmp;
    pos = _oscCenter;
    
    oscAngle += oscSpeed;
    
    updateTail();
  }
  
  public void updateTail()
  {
    if (prevPos.size() >= tailSize)
      prevPos.remove(0);

    if(prevPos.size() == 0)
      prevPos.add(pos);
    else if (prevPos.get(prevPos.size()-1) != pos)
      prevPos.add(pos);
  }
}