import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";
import { GLTFLoader } from "three/addons/loaders/GLTFLoader.js";

import lilGui from "https://cdn.jsdelivr.net/npm/lil-gui@0.21.0/+esm";

import Stats from "https://cdn.jsdelivr.net/npm/stats-js@1.0.1/+esm";

import {
  CSS2DRenderer,
  CSS2DObject,
} from "three/addons/renderers/CSS2DRenderer.js";

const CAMERA_CORDS_DESKTOP = {
  x: 0,
  y: 2,
  z: 6,
  fov: 45,
};
const CAMERA_CORDS_MOBILE = {
  x: 0,
  y: 2,
  z: 7,
  fov: 45,
};

const masterWrapper = document.getElementById("master-wrapper");

const canvasSize = {
  width: masterWrapper.offsetWidth,
  height: masterWrapper.offsetHeight,
};

const sceneData = {
  modelList: [],
  modelMap: new Map(),
};

const scene = new THREE.Scene();
scene.background = null;

const camera = new THREE.PerspectiveCamera(
  45,
  canvasSize.width / canvasSize.height,
  0.1,
  14000
);

camera.aspect = canvasSize.width / canvasSize.height;
camera.updateProjectionMatrix();

const renderer = new THREE.WebGLRenderer({
  antialias: true,
  canvas: document.getElementById("canvas3d"),
});
renderer.setPixelRatio(window.devicePixelRatio);
renderer.setSize(canvasSize.width, canvasSize.height);
renderer.setClearColor(0xffffff, 0);

renderer.outputColorSpace = THREE.SRGBColorSpace;

const orbitControls = new OrbitControls(camera, renderer.domElement);

window.addEventListener("resize", resize);

function resize() {
  canvasSize.width = masterWrapper.offsetWidth;
  canvasSize.height = masterWrapper.offsetHeight;
  // Update canvas sizes
  canvasSize.width = canvasSize.width;
  canvasSize.height = canvasSize.height;

  // Update camera
  camera.aspect = canvasSize.width / canvasSize.height;
  camera.updateProjectionMatrix();
  // Update renderer
  renderer.setSize(canvasSize.width, canvasSize.height);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
}

const loadingManager = new THREE.LoadingManager();
loadingManager.onLoad = () => startScene();

loadingManager.onError = (url) => {
  console.error(`Error loading ${url}`);
};

// load 3d models
const gltfloader = new GLTFLoader(loadingManager);

function loadModelByName(name) {
  gltfloader.load("static/3d_models/" + name + ".glb", function (gltf) {
    let model = gltf.scene;

    console.log(model);

    sceneData.modelMap.set(name, model);
  });
}

loadModelByName("all_in_one");
loadModelByName("straw");
loadModelByName("lid");
loadModelByName("tiger");
loadModelByName("cup");
loadModelByName("cloud_small");
loadModelByName("cloud_big");
loadModelByName("star");
loadModelByName("moon");

// startScene();

function startScene() {
  let allInOne = sceneData.modelMap.get("all_in_one");

  // cupModel.traverse((child) => {
  //     if (child.isMesh) {
  //         const material = child.material;
  //         let nc = new THREE.Color(0x0000ff);
  //         // Check by material name
  //         if (material.name === "black") {
  //             nc = new THREE.Color(0x000000);
  //         } else if (material.name === "orange") {
  //             nc = new THREE.Color(0xff8c3e);
  //         } else if (material.name === "pink") {
  //             nc = new THREE.Color(0xff8766);
  //         } else if (material.name === "out-red") {
  //             nc = new THREE.Color(0xff3d21);
  //         } else if (material.name === "skin") {
  //             nc = new THREE.Color(0xffdeb3);
  //         }

  //         material.emissive = nc;
  //         material.color = nc;
  //         material.emissiveIntensity = 1;
  //         material.needsUpdate = true;
  //     }
  // });

  scene.add(allInOne);
  // enableColorControls(allInOne);

  // Store reference for rotation
  sceneData.mainModel = allInOne;

  // add seperately
  let straw = sceneData.modelMap.get("straw").clone();
  straw.position.set(2, 0, 0);
  // scene.add(straw);

  let lid = sceneData.modelMap.get("lid").clone();
  lid.position.set(4, 0, 0);
  // scene.add(lid);

  let tiger = sceneData.modelMap.get("tiger").clone();
  tiger.position.set(6, 0, 0);
  // scene.add(tiger);

  let cup = sceneData.modelMap.get("cup").clone();
  cup.position.set(8, 0, 0);
  // scene.add(cup);

  let cloud_small = sceneData.modelMap.get("cloud_small").clone();
  cloud_small.position.set(10, 0, 0);
  // scene.add(cloud_small);

  let cloud_big = sceneData.modelMap.get("cloud_big").clone();
  cloud_big.position.set(12, 0, 0);
  // scene.add(cloud_big);

  let star = sceneData.modelMap.get("star").clone();
  star.position.set(14, 0, 0);
  // scene.add(star);

  let moon = sceneData.modelMap.get("moon").clone();
  moon.position.set(16, 0, 0);
  // scene.add(moon);

  ///////

  function enableColorControls(model) {
    const gui = new lilGui({ title: "Cup Colors", width: 300 });
    const colors = {};

    model.traverse((child) => {
      if (child.isMesh) {
        const mat = child.material;
        if (mat && mat.name && !colors[mat.name]) {
          colors[mat.name] = `#${mat.emissive.getHexString()}`;
        }
      }
    });

    Object.entries(colors).forEach(([matName, color]) => {
      gui.addColor(colors, matName).onChange((newValue) => {
        const newColor = new THREE.Color(newValue);

        model.traverse((child) => {
          if (child.isMesh && child.material.name === matName) {
            child.material.color.copy(newColor);
            child.material.emissive.copy(newColor);
            child.material.emissiveIntensity = 1;
            child.material.needsUpdate = true;
          }
        });
      });
    });
  }

  ////

  // 2d stars
  const labelRenderer = new CSS2DRenderer();
  labelRenderer.setSize(canvasSize.width, canvasSize.height);
  labelRenderer.domElement.style.position = "absolute";
  labelRenderer.domElement.style.top = "0px";
  labelRenderer.domElement.style.left = "0px";
  labelRenderer.domElement.style.zIndex = "888";
  labelRenderer.domElement.style.pointerEvents = "none";
  masterWrapper.appendChild(labelRenderer.domElement);

  function createStar(pos, size = 20) {
    const starDiv = document.createElement("div");
    starDiv.className = "star";
    starDiv.style.width = `${size}px`;
    const starLabel = new CSS2DObject(starDiv);
    starLabel.position.copy(pos);
    return starLabel;
  }

  // Create and add star to your scene
  // you can comment the folowing lines to hide 2d stars
  const star1 = createStar(new THREE.Vector3(0, 2, 0), 30);
  scene.add(star1);

  const star2 = createStar(new THREE.Vector3(0.4, 1.5, 0.3), 33);
  scene.add(star2);

  const star3 = createStar(new THREE.Vector3(1.1, 1.1, -0.3), 50);
  scene.add(star3);

  const star4 = createStar(new THREE.Vector3(-0.5, 1, -0.7), 22);
  scene.add(star4);

  const star5 = createStar(new THREE.Vector3(0, 1, 1.2), 45);
  scene.add(star5);

  const star6 = createStar(new THREE.Vector3(1.1, -0.4, -0.3), 22);
  scene.add(star6);

  const star7 = createStar(new THREE.Vector3(-1.1, -0.4, 0.3), 33);
  scene.add(star7);

  ///stats
  const stats = new Stats();
  stats.showPanel(0); // 0: fps, 1: ms (milliseconds per frame), 2: memory
  // Add the stats panel to the document
  // document.body.appendChild(stats.dom);

  const clock = new THREE.Clock();

  function animate() {
    stats.begin();
    requestAnimationFrame(animate);

    // Slowly rotate the boba cup
    if (sceneData.mainModel) {
      sceneData.mainModel.rotation.y += 0.003;
    }

    renderer.render(scene, camera);
    labelRenderer.render(scene, camera);

    stats.end();
  }
  animate();

  const canvas3d = document.getElementById("canvas3d");
}

/// orientation
let orientationIsLandscape = isLandscape();
if (orientationIsLandscape) {
  switchToLandscape();
} else {
  switchToPortrait();
}

function handleOrientationChange() {
  if (isLandscape()) {
    if (!orientationIsLandscape) switchToLandscape();
    orientationIsLandscape = true;
  } else {
    if (orientationIsLandscape) switchToPortrait();
    orientationIsLandscape = false;
  }
}
function isLandscape() {
  return window.innerWidth > 700;
}

window.addEventListener("resize", function () {
  handleOrientationChange();
});

function switchToLandscape() {
  camera.position.set(
    CAMERA_CORDS_DESKTOP.x,
    CAMERA_CORDS_DESKTOP.y,
    CAMERA_CORDS_DESKTOP.z
  );
  camera.fov = CAMERA_CORDS_DESKTOP.fov;
  camera.updateProjectionMatrix();
  orbitControls.update();
  // console.log("toLandscape");
}
function switchToPortrait() {
  camera.position.set(
    CAMERA_CORDS_MOBILE.x,
    CAMERA_CORDS_MOBILE.y,
    CAMERA_CORDS_MOBILE.z
  );
  camera.fov = CAMERA_CORDS_MOBILE.fov;
  camera.updateProjectionMatrix();
  orbitControls.update();
  // console.log("toPortrait");
}

handleOrientationChange();
