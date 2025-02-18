//
// 弾管理クラス
//
class BulletManager
{
  ArrayList<Bullet> bullets;

  // -----------------------------------
  // コンストラクタ
  // -----------------------------------
  BulletManager()
  {
    this.bullets = new ArrayList<Bullet>();
  }

  // -----------------------------------
  // 弾を作成する
  // -----------------------------------
  Bullet createBullet()
  {
    Bullet bullet = new Bullet();
    this.bullets.add(bullet);
    return bullet;
  }
  
  // -----------------------------------
  // 更新
  // -----------------------------------
  void update()
  {
    // 管理しているすべての弾クラスのメソッドを呼び出す
    for (int i = 0; i < this.bullets.size(); i++)
    {
      this.bullets.get(i).move();
      this.bullets.get(i).draw();
    }
    
    Iterator<Bullet> itBullet = this.bullets.iterator();
    while (itBullet.hasNext())
    {
      Bullet b = itBullet.next();
      
      //画面から弾が出た場合は削除
      if(b.y < 0 || b.y > height)
      {
        itBullet.remove();
        continue;
      }
      // 敵の弾かどうか
      if (b.isEnemyBullet)
      {
        // プレイヤーとの当たり判定
        //collision
        if (player.hitTestCircle(b))
        {
          itBullet.remove();
          break;
        }
      }
      else
      {
        // 敵との当たり判定
        ArrayList<Enemy> enemies = enemyManager.getEnemies();
        for (int i = 0; i < enemies.size(); i++)
        {
          if (enemies.get(i).hitTest(b))
          {
            enemies.get(i).damage(1);
            itBullet.remove();
          }
        }
      }
    }
  }
}

//
// 弾クラス
//
class Bullet extends Collision
{
  //int x;
  //int y;
  //int size;
  int speed;
  boolean isEnemyBullet;
  
  // -----------------------------------
  // 移動
  // -----------------------------------
  void move()
  {
    this.y -= this.speed;
  }
  
  // -----------------------------------
  // 描画
  // -----------------------------------
  void draw()
  {
    fill(255, 255, 255);
    circle(this.x, this.y, this.size);
  }
}
