//
// 自機
// 
class Player extends Collision
{
  //int HP = 3;
  boolean isBulletIntervalTime;
  int currentBulletIntervalTime;
  
  // -----------------------------------
  // コンストラクタ
  // -----------------------------------
  Player()
  {
    this.x = width / 2;
    this.y = height / 2;
    this.size = 50;
    this.isBulletIntervalTime = false;
    this.currentBulletIntervalTime = 10;
  }
  
  // -----------------------------------
  // 移動
  // -----------------------------------
  void move()
  {
    if (mouseX != 0 && mouseY != 0)
    {
      this.x = mouseX;
      this.y = mouseY;
    }
    
    // クールタイムだったら
    if (this.isBulletIntervalTime)
    {
      this.currentBulletIntervalTime++;
      
      if (this.currentBulletIntervalTime > 10)
      {
        this.currentBulletIntervalTime = 0;
        this.isBulletIntervalTime = false;
      }
    }
  }
  
  // -----------------------------------
  // 描画
  // -----------------------------------
  void draw()
  {
    if (this.isBulletIntervalTime)
    {
      fill(128, 128, 128);
    }
    else
    {
      fill(255, 255, 255);
    }
    
    // プレイヤーの描画
    circle(this.x, this.y, this.size);
  }
  
  // -----------------------------------
  // 弾を発射する
  // -----------------------------------
  void shot()
  {
    // クールタイムじゃなかったら
    if (!this.isBulletIntervalTime)
    {
      Bullet bullet = bulletManager.createBullet();
      bullet.x = this.x;
      bullet.y = this.y;
      bullet.size = 10;
      bullet.speed = 5;
      
      // クールタイムON
      this.isBulletIntervalTime = true;
    }
    
  }
  boolean hitTestCircle(Bullet b)
  {
    float dist= sqrt(pow(this.x-b.x,2) + pow(this.y - b.y,2));
    //二点間の距離を求める公式 sqrt( (x1-x2)^2 + (y1-y2)^2 )　sqrt→√
    if(dist < this.size/2)
    {
      return true;
    }
    return false;
  }
  
  boolean hitTestCircle2(Enemy a)
  {
    float dist= sqrt(pow(this.x-a.x,2) + pow(this.y - a.y,2));
    //二点間の距離を求める公式 sqrt( (x1-x2)^2 + (y1-y2)^2 )　sqrt→√
    if(dist < this.size/2)
    {
      return true;
    }
    return false;
  }
}
