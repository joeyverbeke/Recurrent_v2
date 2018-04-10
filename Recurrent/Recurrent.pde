import gohai.glvideo.*;
OPC opc;
BouncyBall[] ball = new BouncyBall[10];

int ledCount = 0;

int numRows = 3;
int numColumns = 6;

int testScene = 2;

boolean squares[][] = new boolean[numRows][numColumns];
color squareColors[][] = new color[numRows][numColumns];

color gaussianColor[] = new color[numRows];

int streak_y = 0;
int streak_x = 0;
int streakColor = 0;
int streaktestScene = 0;
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


////COLORS
color RED;
color ORANGE;
color YELLOW;
color BLUE;
color WHITE; 
color GREEN;
color BLACK;
color CYAN;
color PURPLE;

color LIGHT_ORANGE; 
color LIGHT_BLUE;
color LIGHT_PURPLE;
color LIGHT_PINK;
color LIGHT_GREEN;

int scene = 7;
int numScenes = 10;
boolean sceneStarted[] = new boolean[numScenes];
int timeEnteredScene = 0;
float fadeInPercent[] = new float[144];
float directionalFadeInPos = 0.0;
color pixelColor[][] = new color[3][144];
float colorFadePos = 0;

void setup()
{
  size(100, 144, P2D);
  colorMode(HSB, 1.0, 1.0, 1.0, 1.0);

  RED = color(1.0, 1.0, 1.0);
  ORANGE = color(0.0917, 1.0, 1.0);
  YELLOW = color(0.1667, 1.0, 1.0);
  BLUE = color(0.6667, 1.0, 1.0);
  WHITE = color(0, 0, 1.0);
  GREEN = color(0.3334, 1.0, 1.0);
  BLACK = color(0, 0, 0);
  CYAN = color(0.5, 1.0, 1.0);
  PURPLE = color(0.75, 1.0, 1.0);

  LIGHT_ORANGE = color(0.0917, 0.5, 1.0);
  LIGHT_BLUE = color(0.5556, 0.5, 1.0);
  LIGHT_PURPLE = color(0.75, 0.5, 1.0);
  LIGHT_PINK = color(0.8334, 0.5, 1.0);
  LIGHT_GREEN = color(0.333, 0.5, 1.0);

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  //drawRecurrentPixels();

  for (int y=0; y<numColumns; y++)
  {
    for (int x=0; x<numRows; x++)
    {
      squares[x][y] = false;
      squareColors[x][y] = BLACK;
    }
  }

  for (int x=0; x<numRows; x++)
  {
    gaussianColor[x] = color((int)random(255), (int)random(255), (int)random(255), 10);
  }

  if (testScene == 2)
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
    vertColorArray[i] = BLACK;
    fadeInPercent[i] = 0;
  }

  for (int i=0; i<numScenes; i++)
  {
    sceneStarted[i] = false;
  }

  for (int x=0; x<3; x++)
  {
    for (int y=0; y<144; y++)
    {
      pixelColor[x][y] = BLACK;
    }
  }

  background(0);
}

void recurrent()
{
  switch(scene)
  {
  case 0:
    float speed1 = 0.005;

    if (!sceneStarted[scene])
    {
      for (int i=0; i<144; i++)
      {
        fadeInPercent[i] = i * speed1 * -1;
      }
      sceneStarted[scene] = true;
    }

    directionalFadeIn(true, speed1, ORANGE);
    break;

  case 1:
    if (!sceneStarted[scene])
    {
      timeEnteredScene = millis();
      sceneStarted[scene] = true;
    }
    if (millis() - timeEnteredScene > 7000)
    {
      print(millis());
      scene++;
    }

    gaussianSpeckle(ORANGE, YELLOW);
    break;

  case 2:
    if (!sceneStarted[scene])
    {
      timeEnteredScene = millis();
      sceneStarted[scene] = true;
    }
    if (millis() - timeEnteredScene > 7000)
    {
      scene++;
    }

    gaussianSpeckle(ORANGE, RED);
    break;

  case 3:
    float speed3 = 0.0005;

    if (!sceneStarted[scene])
    {
      for (int x=0; x<3; x++)
      {
        for (int y=0; y<144; y++)
        {
          pixelColor[x][y] = get(width/4 + (x * (width/4)), y);
        }
      }
      sceneStarted[scene] = true;
      colorFadePos = 0;
    }

    fadeAllToColor(BLUE, speed3);
    break;

  case 4:
    if (!sceneStarted[scene])
    {
      timeEnteredScene = millis();
      sceneStarted[scene] = true;
    }
    if (millis() - timeEnteredScene > 7000)
    {
      scene++;
    }

    gaussianSpeckle(BLUE, WHITE, GREEN);
    break;

  case 5:
    float speed5 = 0.005;

    if (!sceneStarted[scene])
    {
      for (int x=0; x<3; x++)
      {
        for (int y=0; y<144; y++)
        {
          pixelColor[x][y] = get(width/4 + (x * (width/4)), y);
        }
      }
      sceneStarted[scene] = true;
      colorFadePos = 0;
    }

    fadeAllToColor(BLACK, speed5);
    break;

  case 6:
    if (!sceneStarted[scene])
    {
      for (int i=0; i<144; i++)
      {
        fadeInPercent[i] = 0;
      }
      timeEnteredScene = millis();
      sceneStarted[scene] = true;
    }

    unfold(BLACK, WHITE, 0.005);
    break;

  case 7:
    if (!sceneStarted[scene])
    {
      for (int i=0; i<144; i++)
      {
        fadeInPercent[i] = 0;
      }
      timeEnteredScene = millis();
      sceneStarted[scene] = true;
    }

    unfold(WHITE, BLACK, 0.005);
    break;

  case 8:
    if (!sceneStarted[scene])
    {
      for (int i=0; i<144; i++)
      {
        fadeInPercent[i] = 0;
      }
      timeEnteredScene = millis();
      sceneStarted[scene] = true;
    }

    unfold(BLACK, WHITE, 0.005);
    break;
  case 9:
    if (!sceneStarted[scene])
    {
      for (int i=0; i<144; i++)
      {
        fadeInPercent[i] = 0;
      }
      timeEnteredScene = millis();
      sceneStarted[scene] = true;
    }

    wave();
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

void foldIntoMiddle(color foldInColor, int speed)
{
  fill(foldInColor);
  noStroke();

  rect(0, 0, width, foldInPos);
  rect(0, height - foldInPos, width, foldInPos);

  foldInPos += speed;
  if (foldInPos > 77)
  {
    scene++;
    foldInPos = 0;
  }
}

void unfoldFromMiddle(color backgroundColor, color unfoldColor, int speed)
{

  if (get(0, 0) != backgroundColor)
    background(backgroundColor);

  fill(unfoldColor);
  noStroke();

  rect(0, height/2 - unfoldPos, width, unfoldPos*2);

  unfoldPos += speed;

  if (unfoldPos > 77)
  {
    scene++;
    unfoldPos = 0;
  }
}

void unfold(color fromColor, color toColor, float speed)
{
  if (millis() - timeEnteredScene > speed * 10000 && unfoldPos < 77)
  {
    timeEnteredScene = millis();
    unfoldPos++;
  }

  println(fadeInPercent[0]);

  for (int i=0; i<unfoldPos; i++)
  {
    if (i==76 && fadeInPercent[i] >= 1.0)
    {
      for (int j=0; j<144; j++)
        fadeInPercent[i] = 0;

      unfoldPos = 0;
      scene++;
      break;
    }

    fill(lerpColor(fromColor, toColor, fadeInPercent[i]));
    rect(0, height/2+i, width, 1);
    rect(0, height/2-i, width, 1);

    fadeInPercent[i] += speed;
  }
}

void foldIn(color fromColor, color toColor, float speed)
{
  if (millis() - timeEnteredScene > 1000 && unfoldPos < 77)
  {
    timeEnteredScene = millis();
    unfoldPos++;
  } 

  for (int i=0; i<unfoldPos; i++)
  {
    if (i==76 && fadeInPercent[i] >= 1.0)
    {
      for (int j=0; j<144; j++)
        fadeInPercent[i] = 0;

      unfoldPos = 0;
      scene++;
      break;
    }

    fill(lerpColor(fromColor, toColor, fadeInPercent[i]));
    rect(0, i, width, 1);
    rect(0, height-i, width, 1);

    fadeInPercent[i] += speed;
  }
}

void gaussianSpeckle(color backgroundColor, color speckleColor)
{  
  color speckleWithAlpha = color(hue(speckleColor), saturation(speckleColor), brightness(speckleColor), 0.3);

  //only set the background the first time
  if (get(0, 0) != backgroundColor)
    background(backgroundColor);

  fill(speckleWithAlpha);
  noStroke();

  for (int x=0; x<numRows; x++)
  {
    rect(width/4 + (x * (width/4)), 77 + randomGaussian()*77, 1, 1);
  }
}

void gaussianSpeckle(color backgroundColor, color speckleColor_1, color speckleColor_2)
{  
  color speckle1WithAlpha = color(hue(speckleColor_1), saturation(speckleColor_1), brightness(speckleColor_1), 0.3);
  color speckle2WithAlpha = color(hue(speckleColor_2), saturation(speckleColor_2), brightness(speckleColor_2), 0.3);


  //only set the background the first time
  if (get(0, 0) != backgroundColor)
    background(backgroundColor);

  if (random(1) > 0.5)
    fill(speckle1WithAlpha);
  else
    fill(speckle2WithAlpha);
  noStroke();

  for (int x=0; x<numRows; x++)
  {
    rect(width/4 + (x * (width/4)), 77 + randomGaussian()*77, 1, 1);
  }
}

void fadeAllToColor(color fadeToColor, float speed)
{
  colorFadePos += speed;  

  for (int x=0; x<3; x++)
  {
    for (int y=0; y<144; y++)
    {
      fill(lerpColor(pixelColor[x][y], fadeToColor, colorFadePos));
      rect(width/4 + (x * (width/4)), y, 1, 1);
    }
  }
  if (colorFadePos >= 1)
  {
    scene++;
    colorFadePos = 0;
  }
}

void directionalFadeIn(boolean bottomToTop, float speed, color _color)
{
  directionalFadeInPos++;

  for (int i=0; i<144; i++)
  {
    if (i==143 && fadeInPercent[i] >= 1.0)
    {
      scene++;
      break;
    }

    fadeInPercent[i] += speed;
    color colorWithAlpha = color(hue(_color), saturation(_color), fadeInPercent[i]);
    fill(colorWithAlpha);
    noStroke();

    if (bottomToTop)
    {
      rect(0, height - i, width, 1);
    } else
    {
      rect(0, i, width, 1);
    }
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

public class Wave
{
  float amplitude[][];

  public Wave()
  {
    amplitude = new float[3][144]; 
    for (int x=0; x<3; x++)
    {
      for (int y=0; y<144; y++)
      {
        amplitude[x][y] = abs(cos( PI * (float)(y/77.0)));
      }
    }
  }
}

void wave(color backgroundColor, color waveColor, float speed)
{
  background(WHITE);
  if (get(0, 0) != backgroundColor)
    background(WHITE);

  for (int x=0; x<144; x++)
  {
    waveAmplitude[x][0] += 0.005;
    //fill((int) 255 * abs(cos(waveAmplitude[x][0])));
    fill(1.0, 0, abs(cos(waveAmplitude[x][0])));
    rect(0, x, width, 1);
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
  switch(streaktestScene)
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
          streaktestScene = 1;
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
          streakColor = WHITE;
          break;
        case 3: 
          streakColor = RED;
          break;
        case 5:
          streakColor = ORANGE;
          break;
        case 7:
          streakColor = YELLOW;
          break;
        }
      } else
        streakColor = 0;

      numTimesStreaked++;
      if (numTimesStreaked >= 9)
      {
        numTimesStreaked = 0;
        streaktestScene = 2;
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
        streaktestScene = 0;
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
      gaussianColor[x] = color(random(1.0), random(1.0), random(1.0), 0.3);
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
        float randColor = random(1.0);
        stroke(0, 0, randColor);
        fill(0, 0, randColor);
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
    testScene = 1;
  } else if (key == '2')
  {
    testScene = 2;
    background(0);
  } else if (key == '3')
  {
    testScene = 3;
    background(0);
    fill(255);
  } else if (key == '4')
  {
    testScene = 4;
    background(0);
  } else if (key == '5')
  {
    testScene = 5;
    background(0);
    curtainPosition = 0;
  } else if (key == '6')
  {
    testScene = 6;
    background(0);
    curtainPosition = 0;
  } else if (key == '7')
  {
    testScene = 7;
    background(0);
    curtainPosition = 0;
  } else if (key == '8')
  {
    testScene = 8 ;
  } else if (key == '9')
  {
    testScene = 9;
    background(0, 0, 255);
  } else if (key == '0')
  {
    testScene = 10;
    unfoldPos = 0;
  } else if (key == 'q')
  {
    testScene = 11;
    foldInPos = 0;
  } else if (key == 'w')
  {
    testScene = 12;
    background(0);
    gradientPos = 0;
    frameWhenEnteredAnimation = frameCount;
  } else if (key == 'e')
  {
    testScene = 13;
    background(0);
    gradientPos = 0;
    frameWhenEnteredAnimation = frameCount;
  } else if (key == 'r')
  {
    testScene = 14;
    background(0);
    ball[0] = new BouncyBall((int)random(3), (int)random(144), (int)random(2), color((int)random(255), (int)random(255), 255), random(1.5));
    ball[1] = new BouncyBall((int)random(3), (int)random(144), (int)random(2), color((int)random(255), (int)random(255), 255), random(1.5));
    ball[2] = new BouncyBall((int)random(3), (int)random(144), (int)random(2), color((int)random(255), (int)random(255), 255), random(1.5));
    ball[3] = new BouncyBall((int)random(3), (int)random(144), (int)random(2), color((int)random(255), (int)random(255), 255), random(1.5));
    ball[4] = new BouncyBall((int)random(3), (int)random(144), (int)random(2), color((int)random(255), (int)random(255), 255), random(1.5));
    ball[5] = new BouncyBall((int)random(3), (int)random(144), (int)random(2), color((int)random(255), (int)random(255), 255), random(1.5));
    println();
  } else if (key == 't')
  {
    testScene = 15;
    background(0);
    ball[0] = new BouncyBall(0, random(144), (int)random(2), color(1.0, 1.0, 1.0));
    ball[1] = new BouncyBall(1, random(144), (int)random(2), color(1.0, 1.0, 1.0));
    ball[2] = new BouncyBall(2, random(144), (int)random(2), color(1.0, 1.0, 1.0));
    ball[3] = new BouncyBall(0, random(144), (int)random(2), color(0.5, 0, 1.0));
    ball[4] = new BouncyBall(1, random(144), (int)random(2), color(0.5, 0, 1.0));
    ball[5] = new BouncyBall(2, random(144), (int)random(2), color(0.5, 0, 1.0));
    for (int i=0; i<6; i++)
    {
      ball[i].oscAngle = random(1);
      ball[i].setTailSize(10);
      ball[i].oscCenter = ball[i].pos;
    }
  } else if (key == 'z')
  {
    background(0);
    testScene = 100;
  }
}

void draw()
{
  switch(testScene)
  {
  case 100:
    recurrent();
    break;
  case 1:
    background(YELLOW);
    //background(0);
    //randomBlocks();
    break;

  case 2:
    gaussian();
    break;

  case 3:
    streaks();
    break;

  case 4:
    //wave();
    wave(WHITE, WHITE, 100);
    break;

  case 5:
    curtains(true, 1, ORANGE);
    break;

  case 6:
    curtains(false, 1, BLUE);
    break;

  case 7: 
    gaussianSpeckle(ORANGE, YELLOW);
    break;

  case 8:
    gaussianSpeckle(ORANGE, RED);
    break;

  case 9:
    gaussianSpeckle(BLUE, WHITE, GREEN);
    break;

  case 10:
    unfoldFromMiddle(BLACK, WHITE, 1);
    break;

  case 11:
    foldIntoMiddle(color(0), 1);
    break;

  case 12:
    if (gradientPos <= 1)
      gradient(color(0, 0, (int)(gradientPos * 255)), ORANGE);
    else if (gradientPos > 1 && gradientPos <= 2)
    {
      gradient(BLUE, lerpColor(ORANGE, RED, normalizeGradientPos(gradientPos)));
    } else if (gradientPos > 2 && gradientPos <= 3)
    {
      gradient(lerpColor(BLUE, YELLOW, gradientPos - 2), RED);
    } else if (gradientPos > 3 && gradientPos <= 4)
    {
      gradient(lerpColor(YELLOW, CYAN, gradientPos - 3), lerpColor(RED, PURPLE, normalizeGradientPos(gradientPos)));
    } else if (gradientPos > 4 && gradientPos <= 5)
    {
      gradient(lerpColor(CYAN, BLACK, gradientPos - 4), lerpColor(PURPLE, ORANGE, normalizeGradientPos(gradientPos)));
    } else if (gradientPos > 5)
      gradientPos = 0;

    swipe(0.75, 1);
    swipe(0.5, 1);
    swipe(0.25, 1);
    break;

  case 13:
    if (gradientPos <= 1)
      gradient(lerpColor(RED, BLUE, normalizeGradientPos(gradientPos)), lerpColor(ORANGE, BLUE, normalizeGradientPos(gradientPos)));
    else if (gradientPos > 1 && gradientPos <= 2)
    {
      gradient(BLUE, lerpColor(BLUE, ORANGE, normalizeGradientPos(gradientPos)), BLUE);
    } else if (gradientPos > 2 && gradientPos < 3)
    {
      gradient(lerpColor(BLUE, YELLOW, normalizeGradientPos(gradientPos)), ORANGE, lerpColor(BLUE, YELLOW, normalizeGradientPos(gradientPos)));
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
      gradient(YELLOW, 
        lerpColor(vertColorArray[36], RED, normalizeGradientPos(gradientPos)), 
        ORANGE, 
        lerpColor(vertColorArray[108], RED, normalizeGradientPos(gradientPos)), 
        YELLOW);
    } else if (gradientPos > 4 && gradientPos <= 5)
    {
      gradient(lerpColor(YELLOW, RED, normalizeGradientPos(gradientPos)), 
        lerpColor(RED, ORANGE, normalizeGradientPos(gradientPos)), 
        lerpColor(ORANGE, YELLOW, normalizeGradientPos(gradientPos)), 
        lerpColor(RED, ORANGE, normalizeGradientPos(gradientPos)), 
        lerpColor(YELLOW, RED, normalizeGradientPos(gradientPos)));
    } else if (gradientPos > 5 && gradientPos <= 6)
    {
      gradient(RED, 
        lerpColor(ORANGE, RED, normalizeGradientPos(gradientPos)), 
        lerpColor(YELLOW, ORANGE, normalizeGradientPos(gradientPos)), 
        lerpColor(ORANGE, RED, normalizeGradientPos(gradientPos)), 
        RED);
    } else if (gradientPos > 6 && gradientPos <= 7)
    {
      gradient(lerpColor(RED, ORANGE, normalizeGradientPos(gradientPos)), 
        RED, 
        lerpColor(ORANGE, RED, normalizeGradientPos(gradientPos)), 
        RED, 
        lerpColor(RED, ORANGE, normalizeGradientPos(gradientPos)));
    } else if (gradientPos > 7 && gradientPos <= 8)
    {
      gradient(lerpColor(ORANGE, YELLOW, normalizeGradientPos(gradientPos)), 
        lerpColor(RED, ORANGE, normalizeGradientPos(gradientPos)), 
        RED, 
        lerpColor(RED, ORANGE, normalizeGradientPos(gradientPos)), 
        lerpColor(ORANGE, YELLOW, normalizeGradientPos(gradientPos)));
    } else if (gradientPos > 8 && gradientPos <= 9)
    {
      gradient(YELLOW, 
        lerpColor(ORANGE, YELLOW, normalizeGradientPos(gradientPos)), 
        lerpColor(RED, ORANGE, normalizeGradientPos(gradientPos)), 
        lerpColor(ORANGE, YELLOW, normalizeGradientPos(gradientPos)), 
        YELLOW);
    } else if (gradientPos > 9 && gradientPos <= 10)
    {
      gradient(YELLOW, 
        YELLOW, 
        lerpColor(ORANGE, YELLOW, normalizeGradientPos(gradientPos)), 
        YELLOW, 
        YELLOW);
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

    for (int i=0; i<6; i++)
    {
      ball[i].setDimPercentage(0.98 - (i*0.05));
      ball[i].oscillate(ball[i].oscCenter, (i+1) * 0.02, 10); 
      ball[i].drawToScreen();
      // hi i love you //
    }
    break;
  }
}