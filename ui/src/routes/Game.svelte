<script>
  import { context } from './state.svelte.js';
  import { MyAxesHelper } from './myaxeshelper.svelte.js';
  import * as THREE from 'three';
  import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
  //import { TransformControls } from 'three/examples/jsm/controls/TransformControls';
  import { TransformControls } from 'three/addons/controls/TransformControls.js';
  import { EffectComposer } from 'three/examples/jsm/postprocessing/EffectComposer';
  import { OutlinePass } from 'three/examples/jsm/postprocessing/OutlinePass';
  import { RenderPass } from 'three/examples/jsm/postprocessing/RenderPass';

  const STAR_COLOR = {
    o: 0x92b5ff,
    b: 0xa2c0ff,
    a: 0xd5e0ff,
    f: 0xf9f5ff,
    g: 0xffede3,
    k: 0xffdab5,
    m: 0xffb56c,
  };
  const PLANET_COLOR = {
    earth: 0x43a047,
    gas: 0xe57373,
    ice: 0xd5e3ed,
    water: 0x3949ab,
    desert: 0xffe0b2,
    lava: 0xe65100,
  };
  let gui = $state({
    xyGrid: true,
    yzGrid: false,
  });
  let axes = $state(new MyAxesHelper(100));
  let floor = new THREE.GridHelper(500, 50); // 500 because 250 positive and negative
  floor.position.set(0, 0, 0);
  floor.rotation.set(Math.PI / 2, 0, 0);
  floor.material.opacity = 0.25;
  floor.material.transparent = true;
  let wall1 = new THREE.GridHelper(500, 50);
  wall1.position.set(0, 0, 0);
  wall1.material.opacity = 0.25;
  wall1.material.transparent = true;
  wall1.visible = false;
  let wall2 = new THREE.GridHelper(500, 50);
  wall2.position.set(0, 0, 0);
  wall2.rotation.set(0, 0, Math.PI / 2);
  wall2.material.opacity = 0.25;
  wall2.material.transparent = true;
  wall2.visible = false;

  function makePlanet(p) {
    const geometry = new THREE.SphereGeometry(1, 32, 16);
    //const lineMaterial = new THREE.LineBasicMaterial( { color: 0xffffff, transparent: true, opacity: 0.5 } );
    const material = new THREE.MeshPhongMaterial({
      color: PLANET_COLOR[p.kind],
      emissive: 0x072534,
      side: THREE.DoubleSide,
      flatShading: true,
    });
    /*
    const group = new THREE.Group();
    group.position.set(p.location.x, p.location.y, p.location.z);
    group.add( new THREE.LineSegments( geometry, lineMaterial ) );
    group.add( new THREE.Mesh(geometry, material) );
    return group;
    */
    const planet = new THREE.Mesh(geometry, material);
    planet.position.set(p.x, p.y, p.z);
    return planet;
  }

  function onPointerMove(event, game) {
    const origin = game.renderer.domElement.getBoundingClientRect();
    const x = event.clientX - origin.left;
    const y = event.clientY - origin.top;
    game.pointer.x = (x / width) * 2 - 1;
    game.pointer.y = -(y / height) * 2 + 1;

    game.raycaster.setFromCamera(game.pointer, game.camera);

    const intersects = game.raycaster.intersectObjects(game.entities, false);

    if (intersects.length > 0) {
      const object = intersects[0].object;
      game.outlinePass.selectedObjects = [object];

      //    if (object !== game.transformControl.object) {
      //      game.transformControl.attach(object);
      //    }
    }
  }

  /*
function onPointerDown(event: any, game: GameWorld) {
  game.onDownPosition.x = event.clientX;
  game.onDownPosition.y = event.clientY;
}
function onPointerUp(event: any, game: GameWorld) {
  game.onUpPosition.x = event.clientX;
  game.onUpPosition.y = event.clientY;

  if (game.onDownPosition.distanceTo(game.onUpPosition) === 0) {
    game.transformControl.detach();
  }
}

function onDoubleClick(event: any, game: GameWorld) {
  const origin = game.renderer.domElement.getBoundingClientRect();
  const x = event.clientX - origin.left;
  const y = event.clientY - origin.top;
  game.pointer.x = (x / width) * 2 - 1;
  game.pointer.y = -(y / height) * 2 + 1;

  game.raycaster.setFromCamera(game.pointer, game.camera);

  const intersects = game.raycaster.intersectObjects(game.entities, false);

  if (intersects.length > 0) {
    const object = intersects[0].object;
    console.log(object);
    game.controls.target.set(
      object.position.x,
      object.position.y,
      object.position.z
    );
  }
}
*/


  let gameContainer;
  const width = window.innerWidth, height = window.innerHeight;
  // init
  $effect(() => {
    const scene = new THREE.Scene();
    scene.background = new THREE.Color(0xf5f5f5);

    const renderer = new THREE.WebGLRenderer();
    renderer.setPixelRatio(window.devicePixelRatio);
    renderer.setSize(width, height);
    gameContainer.appendChild( renderer.domElement );
    // shim to prevent the Realm context menu from propagating
    //renderer.domElement.addEventListener('contextmenu', (e) => {
    //  e.stopPropagation();
    //});

    const camera = new THREE.PerspectiveCamera(40, width / height, 0.1, 1000);
    camera.position.set(15, 15, 15);
    camera.up.set(0, 0, 1);
    scene.add(camera);

    // controls
    const controls = new OrbitControls(camera, renderer.domElement);
    controls.dampingFactor = 0.2;
    controls.minDistance = 2;
    controls.maxDistance = 250;
    //const transformControl = new TransformControls(camera, renderer.domElement);
    //transformControl.addEventListener('dragging-changed', function (event) {
    //  controls.enabled = !event.value;
    //});
    //transformControl.addEventListener( 'objectChange', function () {
    //  updatePosition();
    //} );
    //console.log(transformControl);
    //scene.add(transformControl);

    // lights
    const lights = [];
    lights[0] = new THREE.PointLight(0xffffff, 3, 0, 0);
    lights[1] = new THREE.PointLight(0xffffff, 3, 0, 0);
    lights[2] = new THREE.PointLight(0xffffff, 3, 0, 0);
    lights[3] = new THREE.PointLight(0xffffff, 3, 0, 0);
    lights[4] = new THREE.PointLight(0xffffff, 3, 0, 0);
    lights[5] = new THREE.PointLight(0xffffff, 3, 0, 0);

    lights[0].position.set(0, 0, 60);
    lights[1].position.set(0, 0, -60);
    lights[2].position.set(60, 60, 0);
    lights[3].position.set(-60, -60, 0);
    lights[4].position.set(-60, 60, 0);
    lights[5].position.set(60, -60, 0);

    scene.add(lights[0]);
    scene.add(lights[1]);
    scene.add(lights[2]);
    scene.add(lights[3]);
    scene.add(lights[4]);
    scene.add(lights[5]);

    // guidlines: XYZ axes + grid walls
    scene.add(axes);
    scene.add(floor);
    scene.add(wall1);
    scene.add(wall2);

    // draw the star
    const geometry = new THREE.SphereGeometry(context.game.star.radius * 10, 32, 16);
    const lineMaterial = new THREE.LineBasicMaterial({
      color: 0xffffff,
      transparent: true,
      opacity: 0.5,
    });
    const material = new THREE.MeshPhongMaterial({
      color: STAR_COLOR[context.game.star.kind],
      emissive: 0x072534,
      side: THREE.DoubleSide,
      flatShading: true,
    });
    const starGroup = new THREE.Group();
    starGroup.add(new THREE.LineSegments(geometry, lineMaterial));
    starGroup.add(new THREE.Mesh(geometry, material));
    //transformControl.attach(starGroup);
    scene.add(starGroup);

    // draw the planets
    let planets = [];
    for (let p = 0; p < context.game.planets.length; p += 1) {
      if (context.game.planets[p]) {
        const planet = makePlanet(context.game.planets[p]);
        scene.add(planet);
        planets.push(planet);
      }
    }

    // interactivity
    const pointer = new THREE.Vector2();
    const raycaster = new THREE.Raycaster();
    const onUpPosition = new THREE.Vector2();
    const onDownPosition = new THREE.Vector2();

    // misc effects
    const composer = new EffectComposer(renderer);
    const renderPass = new RenderPass(scene, camera);
    composer.addPass(renderPass);
    const outlinePass = new OutlinePass(
      new THREE.Vector2(width, height),
      scene,
      camera
    );
    outlinePass.edgeStrength = 10;
    outlinePass.edgeThickness = 5;
    outlinePass.edgeGlow = 0;
    outlinePass.visibleEdgeColor.set(0x00ffff);
    outlinePass.hiddenEdgeColor.set(0x00ffff);
    outlinePass.renderToScreen = true;
    composer.addPass(outlinePass);

    // animate by rerendering
    const clock = new THREE.Clock();
    const animate = function () {
      const delta = clock.getDelta();
      //gameWorld = updateGameWorld(gameWorld);
      controls.update(delta);
      composer.render();
      requestAnimationFrame(animate);
    };

    animate();

    document.addEventListener('pointermove', (e) =>
      onPointerMove(e, gameWorld)
    );
    /*document.addEventListener('pointerup', (e: any) =>
      onPointerUp(e, gameWorld)
    );
    document.addEventListener('pointerdown', (e: any) =>
      onPointerDown(e, gameWorld)
    );
    document.addEventListener('dblclick', (e: any) =>
      onDoubleClick(e, gameWorld)
    );*/

  });
</script>

<div>
  <div bind:this={gameContainer}></div>
  <div>
    <ul>
      <span>System Details</span>
      <li>
        Star: class {context.game.star.kind.toUpperCase()} radius:{' '}
        {context.game.star.radius} light minutes
      </li>
      <li>Planets: {context.game.planets.length}</li>
      <ul>
        {#each context.game.planets as p}
          {#if p}
            <li>
              Type: {p.kind}, Population: TODO, Radius: {p.radius}
            </li>
          {/if}
        {/each}
      </ul>
    </ul>
    <ul>
      <span>View options</span>
      <li>
        <input type="checkbox" checked={axes.material.visible} onchange={(e) => {
          axes.material.visible = e.target.checked;
        }} />
        Show Axes
      </li>
      <li>
        <input type="checkbox" checked={floor.visible} onchange={(e) => {
          floor.visible = e.target.checked;
        }} />
        XY grid
      </li>
      <li>
        <input type="checkbox" checked={wall1.visible} onchange={(e) => {
          wall1.visible = e.target.checked;
        }} />
        XZ grid
      </li>
      <li>
        <input type="checkbox" checked={wall2.visible} onchange={(e) => {
          wall2.visible = e.target.checked;
        }} />
        YZ grid
      </li>
    </ul>
  </div>
</div>
