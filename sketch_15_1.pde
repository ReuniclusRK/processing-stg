import java.util.*;

class Collision
{
  int x;
  int y;
  int size;
  //自機設定
}

Player player;
BulletManager bulletManager;
EnemyManager enemyManager;

void setup()
{
  size(640, 480);
  
  noStroke();
  
  player = new Player();
  bulletManager = new BulletManager();
  enemyManager = new EnemyManager();
}

void draw()
{
  background(220);
  
  player.move();
  player.draw();
  
  bulletManager.update();
  
  if (mousePressed)
  {
    player.shot();
  }
  
    // 1/100の確率で敵を生成する
  if ((int)random(0, 100) == 0)
  {
    enemyManager.createEnemy();
  }
  
  enemyManager.update();
}
