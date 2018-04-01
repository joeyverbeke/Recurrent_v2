public class BouncyBall {
  int pillar;
  int pos;
  int direction; //0 = up 1 = down 
  color ballColor;
  float speed;
  int frameLastMoved = 0;

  public BouncyBall(int _pillar, int startPos, color _ballColor)
  {
    pillar = _pillar;
    pos = startPos;
    direction = 1;
    ballColor = _ballColor;
  }

  public BouncyBall(int _pillar, int startPos, int startDirection, color _ballColor)
  {
    pillar = _pillar;
    pos = startPos;
    direction = startDirection;
    ballColor = _ballColor;
  }
  
  public BouncyBall(int _pillar, int startPos, int startDirection, color _ballColor, float _speed)
  {
    pillar = _pillar;
    pos = startPos;
    direction = startDirection;
    ballColor = _ballColor;
    speed = _speed;
  }

  public void drawToScreen()
  {
    fill(ballColor);
    rect(pillar * (width/3), pos, (width/3), 1);
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
      if (speed >= 1)
      {
        pos+=speed;
        frameLastMoved = frameCount;
      } else
      {
        int modSpeed = 100 - (int)(speed * 100);
        if(modSpeed >= 10)
          modSpeed = 10;
        if((frameCount - frameLastMoved) % modSpeed == 0)
        {
          pos++;
          frameLastMoved = frameCount;
        }
      }
      
      if (pos >= 144)
        direction = 0;
        
    } else
    {
      if (speed >= 1)
      {
        pos-=speed;
        frameLastMoved = frameCount;
      } else
      {
        int modSpeed = 100 - (int)(speed * 100);
        if((frameCount - frameLastMoved) % modSpeed == 0)
        {
          pos--;
          frameLastMoved = frameCount;
        }
      }
      
      if (pos <= 0)
        direction = 1;
    }
  }

  public void move(int speed)
  {
    if (direction == 1)
    {
      pos += speed;
      if (pos >= 144)
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
      if (ball.pos == this.pos)
        return true;
      else
        return false;
    } else
      return false;
  }
}