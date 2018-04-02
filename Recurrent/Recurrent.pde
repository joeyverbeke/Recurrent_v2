import gohai.glvideo.*;
OPC opc;
BouncyBall[] ball = new BouncyBall[10];

int ledCount = 0;

int numRows = 3;
int numColumns = 6;

int scene = 2;

boolean squares[][] = new boolean[numRows][numColumns];
color squareColors[][] = new color[numRows][numColumns];

color gaussianColor[] = new color[numRows];

int streak_y = 0;
int streak_x = 0;
int streakColor = 0;
int streakScene = 0;
int numTimesStreaked = 0;

float waveAmplitude[][] = new float[144][3];

int curtainPosition = 0;

int frameWhenEnteredAnimation = 0;

int unfoldPos = 0;

int wavePos = 0;

int foldInPos = 0;

float gradientPos = 0.0;
float gradientDelta = 0.003;
color vertColorArray[] = new color[144];

void setup()
{
  size(100, 144, P2D);
  colorMode(HSB, 1.0);

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  //drawRecurrentPixels();

  for (int y=0; y<numColumns; y++)
  {
    for (int x=0; x<numRows; x++)
    {
      squares[x][y] = false;
      squareColors[x][y] = color(0, 0, 0);
    }
  }

  for (int x=0; x<numRows; x++)
  {
    gaussianColor[x] = color((int)random(255), (int)random(255), (int)random(255), 10);
  }

  if (scene == 2)
  {
    stroke(255);
    fill(255);
  }

  for (int y=0; y<3; y++)
  {
    for (int x=0; x<144; x++)
    {
      waveAmplitude[x][y] = abs(cos( PI * (float)(x/77.0)));
    }
  }

  for (int i=0; i<144; i++)
  {
    vertColorArray[i] = color(0, 0, 0);
  }

  background(0);
}

void draw()
{
  switch(scene)
  {
  case 1:
    background(0);
    randomBlocks();
    break;
  case 2:
    gaussian();
    break;
  case 3:
    streaks();
    break;
  case 4:
    //wave();
    wave(color(255), color(255), 100);
    break;
  case 5:
    curtains(true, 1, color(255, 140, 0));
    break;
  case 6:
    curtains(false, 1, color(0, 0, 255));
    break;

  case 7: 
    gaussianSpeckle(color(255, 140, 0), color(255, 255, 0, 30));
    break;

  case 8:
    gaussianSpeckle(color(255, 140, 0), color(255, 0, 0, 30));
    break;

  case 9:
    gaussianSpeckle(color(0, 0, 255), color(255, 255, 255, 30), color(0, 255, 0, 30));
    break;

  case 10:
    unfoldFromMiddle(color(255, 0, 0), color(255, 255, 255), 1);
    break;

  case 11:
    foldIntoMiddle(color(0), 1);
    break;

  case 12:
    if (gradientPos <= 1)
      gradient(color(0, 0, (int)(gradientPos * 255)), color(255, 140, 0));
    else if (gradientPos > 1 && gradientPos <= 2)
    {
      gradient(color(0, 0, 255), lerpColor(color(255, 140, 0), color(255, 0, 0), normalizeGradientPos(gradientPos)));
    } else if (gradientPos > 2 && gradientPos <= 3)
    {
      gradient(lerpColor(color(0, 0, 255), color(255, 255, 0), gradientPos - 2), color(255, 0, 0));
    } else if (gradientPos > 3 && gradientPos <= 4)
    {
      gradient(lerpColor(color(255, 255, 0), color(0, 255, 255), gradientPos - 3), lerpColor(color(255, 0, 0), color(255, 0, 255), normalizeGradientPos(gradientPos)));
    } else if (gradientPos > 4 && gradientPos <= 5)
    {
      gradient(lerpColor(color(0, 255, 255), color(0, 0, 0), gradientPos - 4), lerpColor(color(255, 0, 255), color(255, 140, 0), normalizeGradientPos(gradientPos)));
    } else if (gradientPos > 5)
      gradientPos = 0;

    swipe(0.75, 1);
    swipe(0.5, 1);
    swipe(0.25, 1);
    break;

  case 13:
    if (gradientPos <= 1)
      gradient(lerpColor(color(255, 0, 0), color(0, 0, 255), normalizeGradientPos(gradientPos)), lerpColor(color(255, 140, 0), color(0, 0, 255), normalizeGradientPos(gradientPos)));
    else if (gradientPos > 1 && gradientPos <= 2)
    {
      gradient(color(0, 0, 255), lerpColor(color(0, 0, 255), color(255, 140, 0), normalizeGradientPos(gradientPos)), color(0, 0, 255));
    } else if (gradientPos > 2 && gradientPos < 3)
    {
      gradient(lerpColor(color(0, 0, 255), color(255, 255, 0), normalizeGradientPos(gradientPos)), color(255, 140, 0), lerpColor(color(0, 0, 255), color(255, 255, 0), normalizeGradientPos(gradientPos)));
    } else if (gradientPos > 3 - gradientDelta && gradientPos <= 3 + gradientDelta)
    {
      for (int i=0; i<144; i++)
      {
        vertColorArray[i] = get(width/2, i);
        //println(i + " get:" + hex(get(width/2,i)));
        //println(i + " array:" + hex(vertColorArray[i]));
      }
      gradientPos+=gradientDelta;
    } else if (gradientPos > 3 + gradientDelta && gradientPos <= 4)
    {
      gradient(color(255, 255, 0), 
        lerpColor(vertColorArray[36], color(255, 0, 0), normalizeGradientPos(gradientPos)), 
        color(255, 140, 0), 
        lerpColor(vertColorArray[108], color(255, 0, 0), normalizeGradientPos(gradientPos)), 
        color(255, 255, 0));
    } else if (gradientPos > 4 && gradientPos <= 5)
    {
      gradient(lerpColor(color(255, 255, 0), color(255, 0, 0), normalizeGradientPos(gradientPos)), 
        lerpColor(color(255, 0, 0), color(255, 140, 0), normalizeGradientPos(gradientPos)), 
        lerpColor(color(255, 140, 0), color(255, 255, 0), normalizeGradientPos(gradientPos)), 
        lerpColor(color(255, 0, 0), color(255, 140, 0), normalizeGradientPos(gradientPos)), 
        lerpColor(color(255, 255, 0), color(255, 0, 0), normalizeGradientPos(gradientPos)));
    } else if (gradientPos > 5 && gradientPos <= 6)
    {
      gradient(color(255, 0, 0), 
        lerpColor(color(255, 140, 0), color(255, 0, 0), normalizeGradientPos(gradientPos)), 
        lerpColor(color(255, 255, 0), color(255, 140, 0), normalizeGradientPos(gradientPos)), 
        lerpColor(color(255, 140, 0), color(255, 0, 0), normalizeGradientPos(gradientPos)), 
        color(255, 0, 0));
    } else if (gradientPos > 6 && gradientPos <= 7)
    {
      gradient(lerpColor(color(255, 0, 0), color(255, 140, 0), normalizeGradientPos(gradientPos)), 
        color(255, 0, 0), 
        lerpColor(color(255, 140, 0), color(255, 0, 0), normalizeGradientPos(gradientPos)), 
        color(255, 0, 0), 
        lerpColor(color(255, 0, 0), color(255, 140, 0), normalizeGradientPos(gradientPos)));
    } else if (gradientPos > 7 && gradientPos <= 8)
    {
      gradient(lerpColor(color(255, 140, 0), color(255, 255, 0), normalizeGradientPos(gradientPos)), 
        lerpColor(color(255, 0, 0), color(255, 140, 0), normalizeGradientPos(gradientPos)), 
        color(255, 0, 0), 
        lerpColor(color(255, 0, 0), color(255, 140, 0), normalizeGradientPos(gradientPos)), 
        lerpColor(color(255, 140, 0), color(255, 255, 0), normalizeGradientPos(gradientPos)));
    } else if (gradientPos > 8 && gradientPos <= 9)
    {
      gradient(color(255, 255, 0), 
        lerpColor(color(255, 140, 0), color(255, 255, 0), normalizeGradientPos(gradientPos)), 
        lerpColor(color(255, 0, 0), color(255, 140, 0), normalizeGradientPos(gradientPos)), 
        lerpColor(color(255, 140, 0), color(255, 255, 0), normalizeGradientPos(gradientPos)), 
        color(255, 255, 0));
    } else if (gradientPos > 9 && gradientPos <= 10)
    {
      gradient(color(255, 255, 0), 
        color(255, 255, 0), 
        lerpColor(color(255, 140, 0), color(255, 255, 0), normalizeGradientPos(gradientPos)), 
        color(255, 255, 0), 
        color(255, 255, 0));
    }

    break;

  case 14:
    background(0);
    //println("0:" + ball[0].pos + " direction:" + ball[0].direction);
    //println("1:" + ball[1].pos + " direction:" + ball[1].direction);
    for (int i=0; i<6; i++)
    {
      ball[i].drawToScreen();
      ball[i].move(); 
      for (int j=0; j<6; j++)
      {
        if (j!=i)
        {
          if (ball[i].checkIfSamePos(ball[j]))
          {
            ball[i].switchDirection();
            ball[j].switchDirection();
          }
        }
      }
    }
    //println();
    break;
    
    case 15:
      background(0);
      
      for(int i=0; i<6; i++)
      {
         ball[i].setDimPercentage(0.98 - (i*0.05));
         ball[i].oscillate(ball[i].oscCenter, (i+1) * 0.02, 10); 
         ball[i].drawToScreen();
         // hi i love you //
      }
      break;
  }
}

int getColumnPos(int columnNum)
{
  return (width/4 + (columnNum * (width/4)));
}

float normalizeGradientPos(float _gradientPos)
{
  _gradientPos *= 100.0;
  _gradientPos %= 100.0;
  _gradientPos /= 100.0;
  return _gradientPos;
}


void bouncyBalls()
{
}

void swipe(float speedMultiplier, int size)
{
  fill(255);
  noStroke();

  int pos = (int)((frameCount * speedMultiplier) - frameWhenEnteredAnimation)%144;

  for (int i=0; i<size; i++)
  {
    //fill(color(255, 255, 255, 100 - i));
    rect(0, pos+i, width, 1);
    rect(0, pos-i, width, 1);
  }

  rect(0, ((int)(frameCount/1.5) - frameWhenEnteredAnimation)%144, width, 1);
  rect(0, (frameCount/2 - frameWhenEnteredAnimation)%144, width, 1);
}

void gradient(color color1, color color2)
{
  gradientPos += gradientDelta;

  for (int i=0; i<144; i++)
  {
    fill(lerpColor(color1, color2, (float)(i/144.0)));
    rect(0, i, width, 1);
  }
}

void gradient(color color1, color color2, color color3)
{
  gradientPos += gradientDelta;

  for (int i=0; i<144; i++)
  {
    if (i<72)
    {
      fill(lerpColor(color1, color2, (float)(i/72.0)));
      rect(0, i, width, 1);
    } else
    {
      fill(lerpColor(color2, color3, (float)((i-72)/72.0)));
      rect(0, i, width, 1);
    }
  }
}

void gradient(color color1, color color2, color color3, color color4, color color5)
{
  gradientPos += gradientDelta;

  for (int i=0; i<144; i++)
  {
    if (i<36)
    {
      fill(lerpColor(color1, color2, (float)(i/36.0)));
      rect(0, i, width, 1);
    } else if (i>=36 && i<72)
    {
      fill(lerpColor(color2, color3, (float)((i-36)/36.0)));
      rect(0, i, width, 1);
    } else if (i>=72 && i<108)
    {
      fill(lerpColor(color3, color4, (float)((i-72)/36.0)));
      rect(0, i, width, 1);
    } else if (i>=108)
    {
      fill(lerpColor(color4, color5, (float)((i-108)/36.0)));
      rect(0, i, width, 1);
    }
  }
}

void wave(color backgroundColor, color waveColor, float speed)
{
  if (get(0, 0) != backgroundColor)
    background(backgroundColor);

  for (int x=0; x<144; x++)
  {
    waveAmplitude[x][0] += 0.005;
    fill((int) 255 * abs(cos(waveAmplitude[x][0])));
    rect(0, x, width, 1);
  }
}

void foldIntoMiddle(color foldInColor, int speed)
{
  fill(foldInColor);
  noStroke();

  rect(0, 0, width, foldInPos);
  rect(0, height - foldInPos, width, foldInPos);

  foldInPos += speed;
}

void unfoldFromMiddle(color backgroundColor, color unfoldColor, int speed)
{
  if (get(0, 0) != backgroundColor)
    background(backgroundColor);

  fill(unfoldColor);
  noStroke();

  rect(0, height/2 - unfoldPos, width, unfoldPos*2);

  unfoldPos += speed;
}

void gaussianSpeckle(color backgroundColor, color speckleColor)
{  
  //only set the background the first time
  if (get(0, 0) != backgroundColor)
    background(backgroundColor);

  fill(speckleColor);
  noStroke();

  for (int x=0; x<numRows; x++)
  {
    rect(width/4 + (x * (width/4)), 77 + randomGaussian()*77, 1, 1);
  }
}

void gaussianSpeckle(color backgroundColor, color speckleColor_1, color speckleColor_2)
{  
  //only set the background the first time
  if (get(0, 0) != backgroundColor)
    background(backgroundColor);

  if (random(1) > 0.5)
    fill(speckleColor_1);
  else
    fill(speckleColor_2);
  noStroke();

  for (int x=0; x<numRows; x++)
  {
    rect(width/4 + (x * (width/4)), 77 + randomGaussian()*77, 1, 1);
  }
}

void curtains(boolean bottomToTop, int speed, color _color)
{
  curtainPosition += speed;
  //curtainPosition %= 146;

  fill(_color);
  noStroke();

  for (int x=0; x<numRows; x++)
  {
    if (bottomToTop)
    {
      rect(getColumnPos(x)- width/16, height - curtainPosition, width/8, curtainPosition);
    } else
    {
      rect(getColumnPos(x) - width/16, curtainPosition, width/8, curtainPosition);
    }
  }
}

void wave()
{
  background(0);
  for (int y=0; y<numRows; y++)
  {
    for (int x=0; x<144; x++)
    {
      println("x:" + x + " y:" + y + " " + waveAmplitude[x][y]);
      waveAmplitude[x][y] += 0.005;
      /*
      switch(y)
       {
       case 0:
       fill((int) 255 * abs(cos(waveAmplitude[x][y])), 0, 0);
       break;
       case 1:
       fill(0, (int) 255 * abs(cos(waveAmplitude[x][y])), 0);
       break;
       case 2:
       fill(0, 0, (int) 255 * abs(cos(waveAmplitude[x][y])));
       break;
       }
       */
      fill((int) 255 * abs(cos(waveAmplitude[x][y])));
      //fill((int)(sin( PI * ( (waveAmplitude[x][y] +frameCount) / (144 + frameCount)) ) * 255));
      rect(width/4 + (y * (width/4)), x, 1, 1);
    }
  }
}

void streaks()
{  
  switch(streakScene)
  {
  case 0:
    if (streak_x >= 144)
    {
      if (streak_y >= 2)
      {
        streak_y = 0;
        background(0);
        numTimesStreaked++;
        if (numTimesStreaked >= 6)
        {
          numTimesStreaked = 0;
          streakScene = 1;
          break;
        }
      } else
      {
        streak_y++;
      }
      streak_x = 0;
    } else
    {
      rect(width/4 + (streak_y * (width/4)), 144-streak_x, 1, streak_x);
      streak_x+=15;
    }
    break;

  case 1:
    if (frameCount % 15 == 0)
    {
      if (streakColor == 0)
      {
        switch(numTimesStreaked)
        {
        case 1:
          streakColor = color(255);
          break;
        case 3: 
          streakColor = color(255, 0, 0);
          break;
        case 5:
          streakColor = color(255, 127, 0);
          break;
        case 7:
          streakColor = color(255, 255, 0);
          break;
        }
      } else
        streakColor = 0;

      numTimesStreaked++;
      if (numTimesStreaked >= 9)
      {
        numTimesStreaked = 0;
        streakScene = 2;
        streak_x = 0;
        streak_y = 0;
        streakColor = color(0);
      }
    }
    background(streakColor);
    break;

  case 2:
    background(0);
    rect(width/4 + (streak_y * (width/4)), 0, 10, height);

    if (frameCount % 15 == 0)
      streak_y++;

    if (streak_y >= 3)
    {
      streak_y = 0;
      numTimesStreaked++;
      if (numTimesStreaked >= 4)
      {
        background(0);
        numTimesStreaked = 0;
        streakScene = 0;
      }
    }
    break;
  }
}

void gaussian()
{

  if (frameCount%1000 == 0)
  {
    background(0);
  }
  if (frameCount%250 == 0)
  {
    for (int x=0; x<numRows; x++)
    {
      gaussianColor[x] = color((int)random(255), (int)random(255), (int)random(255), 30);
    }
  }

  for (int x=0; x<numRows; x++)
  {
    //noStroke(); //use for actual implementation
    stroke(gaussianColor[x]);
    fill(gaussianColor[x]);
    rect(width/4 + (x * (width/4)), 77 + randomGaussian()*77, 1, 1);
  }
}

void randomBlocks()
{
  if (frameCount%100 == 0)
  {
    for (int y=0; y<numColumns; y++)
    {
      for (int x=0; x<numRows; x++)
      {
        if (random(2) < 0.5)
        {
          squares[x][y] = true;
        } else
        {
          squares[x][y] = false;
        }
      }
    }
  }

  for (int y=0; y<numColumns; y++)
  {
    for (int x=0; x<numRows; x++)
    {
      println("x:" + x + " y:" + y + " " + squares[x][y]);
      if (squares[x][y] == true)
      {
        int randColor = (int)random(255);
        stroke(randColor);
        fill(randColor);
      } else
      {
        stroke(0);
        fill(0);
      }

      rect(x*(width/numRows), y*(height/numColumns), width/numRows, height/numColumns);
    }
  }
}

void drawRecurrentPixels()
{

  for (int i=0; i<144; i++)
  {
    opc.led(ledCount, width/4, i); 
    ledCount++;
  }
  for (int i=0; i<144; i++)
  {
    opc.led(ledCount, width/2, i); 
    ledCount++;
  }
  for (int i=0; i<144; i++)
  {
    opc.led(ledCount, width - width/4, i); 
    ledCount++;
  }
}

void keyPressed()
{
  if (key == '1')
  {
    scene = 1;
  } else if (key == '2')
  {
    scene = 2;
    background(0);
  } else if (key == '3')
  {
    scene = 3;
    background(0);
    fill(255);
  } else if (key == '4')
  {
    scene = 4;
    background(0);
  } else if (key == '5')
  {
    scene = 5;
    background(0);
    curtainPosition = 0;
  } else if (key == '6')
  {
    scene = 6;
    background(0);
    curtainPosition = 0;
  } else if (key == '7')
  {
    scene = 7;
    background(0);
    curtainPosition = 0;
  } else if (key == '8')
  {
    scene = 8 ;
  } else if (key == '9')
  {
    scene = 9;
    background(0, 0, 255);
  } else if (key == '0')
  {
    scene = 10;
    unfoldPos = 0;
  } else if (key == 'q')
  {
    scene = 11;
    foldInPos = 0;
  } else if (key == 'w')
  {
    scene = 12;
    background(0);
    gradientPos = 0;
    frameWhenEnteredAnimation = frameCount;
  } else if (key == 'e')
  {
    scene = 13;
    background(0);
    gradientPos = 0;
    frameWhenEnteredAnimation = frameCount;
  } else if (key == 'r')
  {
    scene = 14;
    background(0);
    ball[0] = new BouncyBall((int)random(3), (int)random(144), (int)random(2), color((int)random(255), (int)random(255), 255), random(1.5));
    ball[1] = new BouncyBall((int)random(3), (int)random(144), (int)random(2), color((int)random(255), (int)random(255), 255), random(1.5));
    ball[2] = new BouncyBall((int)random(3), (int)random(144), (int)random(2), color((int)random(255), (int)random(255), 255), random(1.5));
    ball[3] = new BouncyBall((int)random(3), (int)random(144), (int)random(2), color((int)random(255), (int)random(255), 255), random(1.5));
    ball[4] = new BouncyBall((int)random(3), (int)random(144), (int)random(2), color((int)random(255), (int)random(255), 255), random(1.5));
    ball[5] = new BouncyBall((int)random(3), (int)random(144), (int)random(2), color((int)random(255), (int)random(255), 255), random(1.5));
    println(); 
  }
  else if (key == 't')
  {
    scene = 15;
    background(0);
    ball[0] = new BouncyBall(0, random(144), (int)random(2), color(1.0, 1.0, 1.0));
    ball[1] = new BouncyBall(1, random(144), (int)random(2), color(1.0, 1.0, 1.0));
    ball[2] = new BouncyBall(2, random(144), (int)random(2), color(1.0, 1.0, 1.0));
    ball[3] = new BouncyBall(0, random(144), (int)random(2), color(0.5, 0, 1.0));
    ball[4] = new BouncyBall(1, random(144), (int)random(2), color(0.5, 0, 1.0));
    ball[5] = new BouncyBall(2, random(144), (int)random(2), color(0.5, 0, 1.0));
    for(int i=0; i<6; i++)
    {
      ball[i].oscAngle = random(1);
      ball[i].setTailSize(10);
      ball[i].oscCenter = ball[i].pos;
    }
  }
}