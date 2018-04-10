public class Wave
{
  float amplitude[][];
  int cyclesCompleted;
  float cyclePos;

  public Wave()
  {
    amplitude = new float[3][LED_MAX]; 
    for (int x=0; x<3; x++)
    {
      for (int y=0; y<LED_MAX; y++)
      {
        amplitude[x][y] = abs(cos( PI * (float)(y/((float)LED_MAX/2))));
      }
    }
    cyclesCompleted = 0;
    cyclePos = 0;
  }

  public Wave(int numDivisions)
  {
    amplitude = new float[3][LED_MAX]; 
    for (int x=0; x<3; x++)
    {
      for (int y=0; y<LED_MAX; y++)
      {
        amplitude[x][y] = abs(cos( PI * (float)(y / ((float)LED_MAX / numDivisions))));
      }
    }
    cyclesCompleted = 0;
    cyclePos = 0;
  }

  public void resetAll()
  {
    for (int x=0; x<3; x++)
    {
      for (int y=0; y<LED_MAX; y++)
      {
        amplitude[x][y] = abs(cos( PI * (float)(y / ((float)LED_MAX / 2))));
      }
    }
    cyclesCompleted = 0;
    cyclePos = 0;
  }

  public void resetAll(int numDivisions)
  {
    for (int x=0; x<3; x++)
    {
      for (int y=0; y<LED_MAX; y++)
      {
        amplitude[x][y] = abs(cos( PI * (float)(y / ((float)LED_MAX / numDivisions))));
      }
    }
    cyclesCompleted = 0;
    cyclePos = 0;
  }

  public void resetCycleCount()
  {
    cyclesCompleted = 0; 
    cyclePos = 0;
  }

  public void setPillar(int pillar, int numDivisions)
  {
    for (int y=0; y<LED_MAX; y++)
    {
      amplitude[pillar][y] = abs(cos( PI * (float)(y / ((float)LED_MAX / numDivisions))));
    }
  }

  public void cycle(float speed)
  {
    for (int x=0; x<3; x++)
    {
      for (int y=0; y<LED_MAX; y++)
      {
        amplitude[x][y] += speed;
        fill(1.0, 0, abs(cos(amplitude[x][y])));
        rect(x*(width/3), y, width/3, 1);
      }
    }
    incrementCycleCount(speed);
  }

  public void cycle(float cycleHue, float speed)
  {
    for (int x=0; x<3; x++)
    {
      for (int y=0; y<LED_MAX; y++)
      {
        amplitude[x][y] += speed;
        fill(cycleHue, 0, abs(cos(amplitude[x][y])));
        rect(x*(width/3), y, width/3, 1);
      }
    }
    incrementCycleCount(speed);
  }

  public void cyclePillar(int pillar, float cycleHue, float speed)
  {
    for (int y=0; y<LED_MAX; y++)
    {
      amplitude[pillar][y] += speed;
      fill(cycleHue, 0, abs(cos(amplitude[pillar][y])));
      rect(pillar*(width/3), y, width/3, 1);
    }
    incrementCycleCount(speed);
  }

  private void incrementCycleCount(float speed)
  {
    cyclePos+=speed;
    println("cyclePos:" + cyclePos);
    
    if (abs(PI - cyclePos) < speed)
    {
      cyclePos = 0;
      cyclesCompleted++;
    }
  }
}