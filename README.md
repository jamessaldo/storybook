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
<img src="/assets/hello_world.png" alt="hello_world" width="450" height="800"/>


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

Ketiga, kalian perlu merubah isi `GameScene.swift` kalian menjadi seperti ini
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

Selanjutnya kalian perlu menambahkan *code* berikut di dalam function sceneDidLoad pada file `GameScene.swift`

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

## **Entity-Component system**

Selanjutnya kita akan mempelajari ECS secara sederhana dari GameplayKit. Sebenarnya GameplayKit memiliki banyak *tools* yang dapat kita gunakan selain ECS, seperti *Agents*, *Goals*, *Behaviors*, *pathfinding*, *randomization*, *state machines*, *rule systems*, dan masih banyak lagi. Namun pada kesempatan kali ini penulis hanya akan memperkenalkan ECS kepada kalian.

Mari kita pelajari terlebih dahulu mengenai pengertian dari *Entity* dan *Component*.

**Entities**: Entitas merupakan sebuah representasi dari sebuah objek, dimana pada kasus aplikasi ini adalah *character*.
**Components**: Komponen berisikan sebuah logika yang akan menjalakan suatu spesifik hal untuk sebuah entitas, biasanya suatu komponen akan mewakilkan suatu aksi dari sebuah entitas seperti komponen gerak, komponen untuk mengeluarkan suara, dan sebagainya.

Langkah selanjutnya, mari kita buat sebuah entitas bernama *Character* di dalam suatu folder bernama *Entities*. 
Buatlah sebuah file bernama `Character.swift` di dalam folder *Entities* kemudian masukkan *code* berikut.
```
import SpriteKit
import GameplayKit

class Character: GKEntity {

    init(imageName: String) {
        super.init()

        var characterAtlas: SKTextureAtlas {
            return SKTextureAtlas(named: imageName)
        }

        var characterTexture: SKTexture {
            return characterAtlas.textureNamed(imageName)
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

        let spriteComponent = SpriteComponent(
            entity: self,
            texture: characterTexture,
            size: characterTexture.size()
        )
        addComponent(spriteComponent)

        let idleAnimation = SKAction.animate(with: characterIdleTexture, timePerFrame: 0.2)
        spriteComponent.node.run(SKAction.repeatForever(idleAnimation), withKey: "chracterIdleAnimation")

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
```

Kemudian kita akan membuat sebuah komponen bernama SpriteComponent. Komponen ini dibutuhkan sebagai *sprite node* yang akan ditampilkan dalam suatu halaman.
Buatlah sebuah file bernama `SpriteComponent.swift` di dalam folder *Components* kemudian masukkan *code* berikut.
```
import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    // A node that gives an entity a visual sprite
    let node: SKSpriteNode

    init(entity: GKEntity, texture: SKTexture, size: CGSize) {
        node = SKSpriteNode(texture: texture, color: SKColor.white, size: size)
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
```

Selanjutnya kita perlu membuat sebuah *EntityManager* yang akan mengatur setiap entitas yang telah kita buat maupun hapus.
Buatlah sebuah file bernama `EntityManager.swift` di dalam folder *Entities* kemudian masukan *code* berikut.
```
import Foundation
import SpriteKit
import GameplayKit

class EntityManager {

    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    let scene: SKScene

    init(scene: SKScene) {
        self.scene = scene
    }

    func add(_ entity: GKEntity) {
        entities.insert(entity)

        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }

    }

    func remove(_ entity: GKEntity) {

        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }

        toRemove.insert(entity)
        entities.remove(entity)
    }

    func update(_ deltaTime: CFTimeInterval) {
        toRemove.removeAll()
    }
}
```


Terakhir, mari kita implementasikan Entitas dan Komponen yang telah kita buat ke dalam `GameScene.swift` sebagai berikut.
```
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let background = SKSpriteNode(imageNamed: "background")
    var character: Character?

    // Entity-component system
    var entityManager: EntityManager!

    override func sceneDidLoad() {
        // Create entity manager
        entityManager = EntityManager(scene: self)

        // Add background
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: size.width, height: size.height)
        background.zPosition = -1
        addChild(background)

        // Add animated character
        character = Character(imageName: "LionStoryAnimation")
        if let spriteComponent = character?.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: 0, y: -80)
            spriteComponent.node.zPosition = 10
        }

        if let character = character {
            entityManager.add(character)
        }
    }
}
```

Voila! Kalian akan mendapatkan hasil yang sama layaknya hasil sebelumnya (tanpa ECS). Keunggulan penggunaan ECS dibandingkan tanpa ECS ialah mengurangi redudansi *code* yang kalian tulis, serta membuat lebih mudah bagi seorang *engineer* baru dalam memahami *code* kalian.

Selanjutnya, kalian bisa coba melakukan hal serupa dengan menjadikan *background* sebagai entitas dan implementasikan pada file `GameScene.swift`!

Semoga kalian dapat memahami implementasi ECS + Texture Atlas dengan mudah yaa. Terima kasih telah membaca~
