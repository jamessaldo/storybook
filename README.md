# **How to create animated character in Swift**

## **Intros**
<img src="/assets/animated_intros.gif" alt="animated_intros" />

Halo semua! Perkenalkan saya Ghozy, pada kesempatan kali ini saya ingin berbagi tentang bagaimana cara membuat sebuah karakter yang bisa bergerak (animasi) menggunakan *framework* SpriteKit & GameplayKit di bahasa pemrograman Swift!

Sebelum membahas lebih jauh mengenai pembuatan animasi dalam SpriteKit, penulis pada kali ini juga menggunakan GameplayKit untuk membungkus objek yang telah dibuat melalui SpriteKit ke dalam sebuah ECS dari GameplayKit. GameplayKit merupakan sebuah *framework* yang diperkenalkan sejak dirilisnya iOS 9 dan kehadirannya membuat pembuatan *game* lebih mudah.

## **Let's having fun with SpriteKit**

Mula-mula, mari kita buat terlebih dahulu *project* baru di Xcode sebagai berikut
Pada tampilan ini, pilihlah template *Game*, kemudian *next*

![choose template](/assets/choose_template.png)

Kemudian kalian bisa memberikan nama *project* ini sesuka kalian, pada kali ini penulis memberikan nama AnimatedTutorial. Pada tampilan ini kalian juga perlu memastikan bahwa *Game Technology* yang digunakan adalah SpriteKit dan kalian telah mencentang *Integrate GameplayKit* ya!

![init project](/assets/init_project.png)

Setelah itu kalian akan mendapati tampilan seperti ini, kalian dapat mencoba menjalankan *code* yang telah ada terlebih dahulu untuk memastikan bahwa semua berjalan dengan normal.

<img src="/assets/homepage.png" alt="homepage"/>
<img src="/assets/hello_world.png" alt="hello_world" width="600" height="1000"/>


## **Project Preparation**

Selanjutnya kita akan membuat sebuah halaman yang dapat menampilkan background dan sebuah karakter.

Pertama, kalian perlu merubah isi dari GameViewController kalian menjadi seperti ini

```
import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }

    override var shouldAutorotate: Bool {
        true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
```

Kedua, kalian perlu menghapus file **Actions.sks** dan menghapus seluruh content yang ada di **GameScene.sks** serta merubah size-nya menggunakan iPad.
![Game Scene](/assets/setup_gamescene.png)

Ketiga, kalian perlu merubah isi **GameScene.swift** kalian menjadi seperti ini
```
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let background = SKSpriteNode(imageNamed: "background")
    
    override func sceneDidLoad() {
        // Add background
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: size.width, height: size.height)
        background.zPosition = -1
        addChild(background)
    }
}
```

Pada *code* di atas, penulis memanggil *image* yang berada di *Assets* bernama *background* dan melakukan inisialisasi SKSpriteNode yang akan ditambahkan ke dalam *root node* pada halaman **GameScene**.
Kalian akan mendapatkan tampilan sebagai berikut.
![Initialize background](/assets/first_background.png)


## **Texture Atlases**

Pada tahap ini kalian perlu menyiapkan *assets* berupa kumpulan gambar yang akan kita jadikan satu sebagai objek *texture atlases* pada Swift.

<img src="/assets/create_atlas.png" alt="create_atlas"/>

Setelah kalian berhasil membuat *base* dari sebuah atlas, kalian tinggal memasukkan gambar karakter yang telah disiapkan ke dalam folder atlas yang telah dibuat.
<img src="/assets/created_atlas.png" alt="created_atlas"/>

Selanjutnya kalian perlu menambahkan *code* berikut di dalam function sceneDidLoad pada file **GameScene.swift**

```
// Add animated character
var characterAtlas: SKTextureAtlas {
    return SKTextureAtlas(named: "LionStoryAnimation")
}

var characterTexture: SKTexture {
    return characterAtlas.textureNamed("LionStoryAnimation")
}

var characterIdleTexture: [SKTexture] {

    var index: [SKTexture] = []
    let imagesName = characterAtlas.textureNames

    for name in imagesName {
        let textureNames = characterAtlas.textureNamed(name)
        index.append(textureNames)
    }
    return index

}
character = SKSpriteNode(texture: characterTexture)
character.zPosition = 10
character.position = CGPoint(x: 0, y: -80)
let idleAnimation = SKAction.animate(with: characterIdleTexture, timePerFrame: 0.2)
character.run(SKAction.repeatForever(idleAnimation), withKey: "chracterIdleAnimation")
addChild(character)
```

Voila! kalian akan mendapatkan tampilan seperti ini. Kalian telah berhasil dalam membuat sebuah *animated character* pada SpriteKit menggunakan Texture Atlases. Selanjutnya kita akan mencoba implementasi ECS dengan memanfaatkan *framework* GameplayKit!
<img src="/assets/spritekit_animated_character.gif" alt="spritekit_animated_character" />
