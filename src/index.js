import * as ms from "@magenta/sketch";
import p5 from "p5";

let model;
let dx, dy; // offsets of the pen strokes, in pixels
let pen_down, pen_up, pen_end; // keep track of whether pen is touching paper
let x, y; // absolute coordinates on the screen of where the pen is
let prev_pen = [1, 0, 0]; // group all p0, p1, p2 together
let rnn_state; // store the hidden states of rnn's neurons
let pdf; // store all the parameters of a mixture-density distribution
let temperature = 0.45; // controls the amount of uncertainty of the model
let line_color;
let model_loaded = false;

// loads the TensorFlow.js version of sketch-rnn model, with the "cat" model's weights.
model = new ms.SketchRNN(
    "https://storage.googleapis.com/quickdraw-models/sketchRNN/large_models/spider.gen.json"
);
// code that ensures the above line is run before the below lines are run.

function setup() {
    console.log("Hi");
    x = window.innerWidth / 2.0;
    y = window.innerHeight / 3.0;
    createCanvas(window.innerWidth, window.innerHeight);
    frameRate(60);

    // Initialize the scale factor for the model. Bigger -> large outputs.
    model.setPixelFactor(3.0);

    // Initialize pen's states to zero.
    [dx, dy, pen_down, pen_up, pen_end] = model.zeroInput(); // The pen's states.

    // Zero out the rnn's initial states.
    rnn_state = model.zeroState();

    // Define color of line.
    line_color = color(random(64, 224), random(64, 224), random(64, 224));
}

function draw() {
    // See if we finished drawing.
    if (prev_pen[2] == 1) {
        noLoop(); // Stop drawing.
        return;
    }

    // Using the previous pen states, and hidden state, get next hidden state
    // the below line takes the most CPU power, especially for large models.
    rnn_state = model.update([dx, dy, pen_down, pen_up, pen_end], rnn_state);

    // Get the parameters of the probability distribution (pdf) from hidden state.
    pdf = model.getPDF(rnn_state, temperature);

    // Sample the next pen's states from our probability distribution.
    [dx, dy, pen_down, pen_up, pen_end] = model.sample(pdf);

    // Only draw on the paper if the pen is touching the paper.
    if (prev_pen[0] == 1) {
        stroke(line_color);
        strokeWeight(3.0);
        line(x, y, x + dx, y + dy); // Draw line connecting prev point to current point.
    }

    // Update the absolute coordinates from the offsets
    x += dx;
    y += dy;

    // Update the previous pen's state to the current one we just sampled
    prev_pen = [pen_down, pen_up, pen_end];
}
