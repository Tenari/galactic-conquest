import * as THREE from 'three';
export class MyAxesHelper extends THREE.LineSegments {
  constructor(size = 1) {
    const vertices = [
      -1 * size,  0, 0,
      size,       0, 0,
      0, -1 * size,  0,
      0, size,       0,
      0, 0,  -1 * size,
      0, 0, size,
    ];

    const colors = [1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1];

    const geometry = new THREE.BufferGeometry();
    geometry.setAttribute(
      'position',
      new THREE.Float32BufferAttribute(vertices, 3)
    );
    geometry.setAttribute('color', new THREE.Float32BufferAttribute(colors, 3));

    const material = new THREE.LineBasicMaterial({
      vertexColors: true,
      toneMapped: false,
    });

    super(geometry, material);

    this.type = 'AxesHelper';
  }

  setColors(xAxisColor, yAxisColor, zAxisColor) {
    const color = new THREE.Color();
    const array = this.geometry.attributes.color.array;

    color.set(xAxisColor);
    color.toArray(array, 0);
    color.toArray(array, 3);

    color.set(yAxisColor);
    color.toArray(array, 6);
    color.toArray(array, 9);

    color.set(zAxisColor);
    color.toArray(array, 12);
    color.toArray(array, 15);

    this.geometry.attributes.color.needsUpdate = true;

    return this;
  }

  dispose() {
    this.geometry.dispose();
    this.material.dispose();
  }
}


