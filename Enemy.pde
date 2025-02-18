//
// 敵管理クラス
//
int score = 0;
//score = 200*nの時にボス出現させる
//int n = 1;

class EnemyManager
{
  ArrayList<Enemy> enemies;

  boolean hasRun = false;

  EnemyManager()
  {
    this.enemies = new ArrayList<Enemy>();
  }

  ArrayList<Enemy> getEnemies()
  {
    return this.enemies;
  }


  Enemy createEnemy()
  {
    int type = (int)random(0, 5);
    //int type = 4;

    Enemy enemy = null;

    if (type == 0)
    {
      enemy = new ReturnEnemy();
    } else if (type == 1)
    {
      enemy = new StraightEnemy();
    } else if (type == 2)
    {
      enemy = new RightMoveEnemy();
    } else if (type == 3)
    {
      enemy = new LeftMoveEnemy();
    } else if (type == 4)
    {
      enemy = new RemainEnemy();
    }
    if (score <= 200 && !hasRun)
      //一度だけボスエネミーを出現させる
    {
      //n += 1;
      enemy = new BossEnemy();
      hasRun = true;
    }
    this.enemies.add(enemy);

    return enemy;
  }

  void update()
  {
    //スコア管理
    fill(0);
    textSize(50);
    text(score, 10, 35);

    Iterator<Enemy> itEnemy1 = this.enemies.iterator();
    while (itEnemy1.hasNext())
    {
      Enemy a = itEnemy1.next();
      // プレイヤーとの当たり判定
      //collision
      if (player.hitTestCircle2(a))
      {
        score += 0;
      }
    }

    for (int i = 0; i < this.enemies.size(); i++)
    {
      this.enemies.get(i).move();
      this.enemies.get(i).draw();
    }

    //死亡判定
    Iterator<Enemy> itEnemy2 = this.enemies.iterator();
    //この場合、iteratorを分けないとhasnextで次→次と２回進んでしまうので、iteratorを二つに分けないといけない

    while (itEnemy2.hasNext())
    {
      Enemy enemy = itEnemy2.next();

      if (enemy.isDead)
      {
        itEnemy2.remove();
      }
    }
  }
}

//
// 敵クラス
//
class Enemy extends Collision
{
  int type;
  int count;
  int speed;
  boolean isDead;
  int life;

  void move()
  {
  }

  void draw()
  {
    fill(224, 255, 253);
    rect(this.x, this.y, this.size, this.size);
  }

  void shot()
  {
    Bullet bullet = bulletManager.createBullet();
    bullet.x = this.x + this.size / 2;
    bullet.y = this.y + this.size / 2;
    bullet.size = 10;
    bullet.speed = -5;
    bullet.isEnemyBullet = true;
  }

  void damage(int value)
  {
    this.life -= value;

    if (this.life <= 0)
    {
      this.isDead = true;
      score += 10;
    }
  }

  boolean hitTest(Bullet bullet)
  {
    if (bullet.x > this.x && bullet.y > this.y && bullet.x < this.x + this.size && bullet.y < this.y + this.size)
    {
      return true;
    }
    return false;
  }
}

//
// 画面上から出てきて途中で止まって上に戻る
//
class ReturnEnemy extends Enemy
{
  ReturnEnemy()
  {
    this.size = (int)random(50, 70);
    this.x = (int)random(0, width - this.size);
    this.y = -this.size;
    this.count = 0;
    this.speed = (int)random(2, 6);
    this.life = 3;
  }

  // 親クラスのメソッドと同じ名前で定義すると上書きできる
  void move()
  {
    this.count++;

    if (this.count < 50)
    {
      this.y += this.speed;
    } else if (this.count > 150)
    {
      this.y -= this.speed;

      if (this.y + this.size < 0)
      {
        this.isDead = true;
      }
    }

    // 1/50の確率で弾を発射する
    if ((int)random(50) == 0)
    {
      this.shot();
    }
  }
}

//
// 画面上から下へ
//
class StraightEnemy extends Enemy
{
  StraightEnemy()
  {
    this.size = (int)random(50, 70);
    this.x = (int)random(0, width - size);
    this.y = -this.size;
    this.count = 0;
    this.speed = (int)random(2, 4);
    this.life = 3;
  }

  void move()
  {
    this.count++;

    this.y += this.speed;

    if (this.y > height)
    {
      this.isDead = true;
    }

    // 1/50の確率で弾を発射する
    if ((int)random(50) == 0)
    {
      this.shot();
    }
  }
}

//
// 右から左へ
//
class LeftMoveEnemy extends Enemy
{
  LeftMoveEnemy()
  {
    this.size = (int)random(50, 70);
    this.x = width;
    this.y = (int)random(0, height/3);
    this.count = 0;
    this.speed = (int)random(2, 4);
    this.life = 3;
  }

  void move()
  {
    this.count++;

    this.x -= this.speed;

    if (this.x < 0)
    {
      this.isDead = true;
    }

    // 1/50の確率で弾を発射する
    if ((int)random(50) == 0)
    {
      this.shot();
    }
  }
}

//
// 左から右へ
//
class RightMoveEnemy extends Enemy
{
  RightMoveEnemy()
  {
    this.size = (int)random(50, 70);
    this.x = -this.size;
    this.y = (int)random(0, height/3);
    this.count = 0;
    this.speed = (int)random(2, 4);
    this.life = 3;
  }

  void move()
  {
    this.count++;

    this.x += this.speed;

    if (this.x > width)
    {
      this.isDead = true;
    }

    // 1/50の確率で弾を発射する
    if ((int)random(50) == 0)
    {
      this.shot();
    }
  }
}

//
//横の壁に反射するenemy
//
class RemainEnemy extends Enemy
{
  int moveX;
  int moveY;

  RemainEnemy()
  {
    this.size = (int)random(50, 70);
    this.x = (int)random(width - this.size);
    //this.y = (int)random(height - this.size);
    this.y = 0 -this.size;
    //this.moveX = (int)random(-5,5);
    this.count = 0;
    //this.speed = (int)random(4,6);
    this.moveX = 1;
    this.moveY = 1;
    this.life = 4;
  }

  void move()
  {
    this.count++;
    //this.x += this.moveX;
    this.x += this.moveX;
    this.y += this.moveY;

    if (this.x < 0 || this.x > width - this.size)
    {
      this.moveX *= -1;
    }
    //if (this.y < 0 || this.y > height - this.size)
    //{
    //  this.moveY *= -1;
    //}


    //1/30の確率で弾を発射する
    if ((int)random(70) == 0)
    {
      this.shot();
    }
  }
}

class BossEnemy extends Enemy
{
  int i = -480;
  boolean run = false;

  void draw()
  {
    fill(0, 0, 0, 50);

    ellipse( width/2, i, this.size * 1.5, this.size * 1.5 );

    if (i < 0) {
      i+= 5;
    } 
    //ellipseは描画してるだけで、それ自体に当たり判定はない

    //bosslife
    textSize(50);
    text(this.life, 580, 35);
  }
  BossEnemy()
  {
    this.size = (int)random(200, 250);
    this.x = width / 2;
    this.y = -this.size; // 画面外からスタート
    this.count = 0;
    this.life = 50;
  }

  void shot()
  {
    Bullet bullet = bulletManager.createBullet();
    if (bullet != null) {
      //bullet.x = this.x + this.size / 2;
      bullet.x = (int)random(this.x*0.5, this.x* 1.5);
      bullet.y = this.size / 3;
      bullet.size = 15;
      bullet.speed = -5;
      bullet.isEnemyBullet = true;
    }
  }

  void damage(int value)
  {
    
    if (i < 0) {
      i+= 5;
    } else {
      if (!run) {
        run = true;
      }
    }
    //ボスが完全に描画されるまでダメージを受けないようにする
    if (run == true) {
      this.life -= value;
      println("aaaa");

      if (this.life <= 0)
      {
        this.isDead = true;
        score += 50;
      }
    }
  }

  void move()
  {
    this.count++;
    if (this.count > 150) {
      // 停止後に弾を発射する
      if ((int)random(10) == 0) { // 1/0の確率で弾を発射
        this.shot();
      }
    }
  }


  boolean hitTest(Bullet b)
  {
    float dist= sqrt(pow(width/2-b.x, 2) + pow(0 - b.y, 2));
    //二点間の距離を求める公式 sqrt( (x1-x2)^2 + (y1-y2)^2 )　sqrt→√
    if (dist < this.size * 1.5 / 2.0)
    {
      return true;
    }
    return false;
  }
}
