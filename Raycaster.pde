/* Simple raycaster             */
/* @author jpkniem@gmail.com   */
/** NOTE: Something wrong when pressing UP or DOWN key (camera is moving incorrectly to left and right) */

/* Direction vector */
double dirX = -1;
double dirY = 0;

/* Player position */
double posX = 22;
double posY = 12;

/* Camera plane */
double planeX = 0.0;
double planeY = 0.66;

final int mapWidth = 24;
final int mapHeight = 24;

int worldMap[][] = {
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 0, 0, 0, 0, 3, 0, 3, 0, 3, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 2, 2, 0, 2, 2, 0, 0, 0, 0, 3, 0, 3, 0, 3, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 4, 0, 4, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 4, 0, 0, 0, 0, 5, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 4, 0, 4, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 4, 0, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
};

float moveSpeed = 1.2f;
float rotSpeed = 5.0f;

float newRotSpeed = 0;
float newMoveSpeed = 0;

void keyPressed() {
  if(key == CODED) {
    if(keyCode == UP) {
      if(worldMap[(int)(posX + dirX * newMoveSpeed)][(int)(posY)] == 0) posX += dirX * newMoveSpeed;
      if(worldMap[(int)(posX)][(int)(posY + dirY * newMoveSpeed)] == 0) posY += dirY * newMoveSpeed; 
    }
    
    if(keyCode == DOWN) {
      if(worldMap[(int)(posX - dirX * newMoveSpeed)][(int)(posY)] == 0) posX -= dirX * newMoveSpeed;
      if(worldMap[(int)(posX)][(int)(posY - dirY * newMoveSpeed)] == 0) posY -= dirY * newMoveSpeed;
    }
    
    if(keyCode == LEFT) {
      double oldDirX = dirX;
      dirX = dirX * cos(-newRotSpeed) - dirY * sin(-newRotSpeed);
      dirY = oldDirX * sin(-newRotSpeed) + dirY * cos(-newRotSpeed);
        
      double oldPlaneX = planeX;
      planeX = planeX * cos(-newRotSpeed) - planeY * sin(-newRotSpeed);
      planeY = oldPlaneX * sin(-newRotSpeed) + planeY * cos(-newRotSpeed);

    }
    
    if(keyCode == RIGHT) {
      double oldDirX = dirX;
      dirX = dirX * cos(newRotSpeed) - dirY * sin(newRotSpeed);
      dirY = oldDirX * sin(newRotSpeed) + dirY * cos(newRotSpeed);
      
      double oldPlaneX = planeX;
      planeX = planeX * cos(newRotSpeed) - planeY * sin(newRotSpeed);
      planeY = oldPlaneX * sin(newRotSpeed) + planeY * cos(newRotSpeed);
    }
  }
}

void setup() {
  size(512, 384);
  background(0);
}
int lastTime = 0;
int delta = 0;

void draw() {
  delta = millis() - lastTime;
  newRotSpeed = rotSpeed * delta/100.0f;
  newMoveSpeed = moveSpeed * delta/100.0f;
  
  // X goes through camera plane with values -1..0..1 (length 2)
  clear();
  loadPixels();
  for (int x = 0; x < width; x++) {
    double cameraX = 2 * x / (double)width - 1;
    double rayDirX = planeX + dirX * cameraX;
    double rayDirY = planeY + dirY * cameraX;
    int mapX = (int)posX;
    int mapY = (int)posY;

    double sideDistX = 0;
    double sideDistY = 0;

    double deltaDistX = abs((float)(1.0/rayDirX));
    double deltaDistY = abs((float)(1.0/rayDirY));
    double perpWallDist = 0;

    int stepX = 0;
    int stepY = 0;

    boolean hit = false;
    int side = 0;

    if (rayDirX < 0) {
      stepX = -1;
      sideDistX = (posX - mapX) * deltaDistX;
    } else {
      stepX = 1;
      sideDistX = (mapX + 1.0 - posX) * deltaDistX;
    }
    if (rayDirY < 0) {
      stepY = -1;
      sideDistY = (posY - mapY) * deltaDistY;
    } else {
      stepY = 1;
      sideDistY = (mapY + 1.0 - posY) * deltaDistY;
    }

    while (!hit) {
      if (sideDistX < sideDistY) {
        side = 0;
        sideDistX += deltaDistX;
        mapX += stepX;
      } else {
        side = 1;
        sideDistY += deltaDistY;
        mapY += stepY;
      }
      if (worldMap[mapX][mapY] > 0) {
        hit = true;
      }
    }
    
    if(side == 0) {
     perpWallDist = (mapX - posX + (1 - stepX) / 2) / rayDirX; 
    }
    else {
     perpWallDist = (mapY - posY + (1 - stepY) / 2) / rayDirY;
    }
    
    int lineHeight = (int)(height / perpWallDist);
    int drawStart = -lineHeight / 2 + height / 2;
    if(drawStart < 0) drawStart = 0;
    int drawEnd = lineHeight / 2 + height / 2;
    if(drawEnd >= height) drawEnd = height - 1;
    
    for(int y = drawStart; y < drawEnd; y++) {
      pixels[y * width + x] = color(1.0/(float)perpWallDist * 255, 1.0/(float)perpWallDist * 255, 1.0/(float)perpWallDist * 255);
    }
  updatePixels();
  }
  lastTime = millis();
}
