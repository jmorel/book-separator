
float LETTER_SIZE = 200;

int CANVAS_WIDTH = 800;
int CANVAS_HEIGHT = 500;

// parameters
float step = 0.01;
boolean same_keypress = false;
float baseline = 250;
boolean init = true;
float scalar_ascent = 1;
float scalar_caps = 1;
float scalar_xheight = 1;
float scalar_descent = 1;

void setup() 
{
    size(CANVAS_WIDTH, CANVAS_HEIGHT);
    PFont font = createFont("Georgia", LETTER_SIZE);
    textFont(font);
}

void draw() {
    if (init) {
      init = false;
      draw_text();
    }

    if (!keyPressed) {
      same_keypress = false;
    }
    if (keyPressed && !same_keypress) {
      same_keypress = true;

      if (key == 'q') { scalar_ascent += step; } 
      if (key == 'a') { scalar_ascent -= step; } 
      if (key == 'w') { scalar_descent += step; } 
      if (key == 's') { scalar_descent -= step; } 
      if (key == 'e') { scalar_xheight += step; } 
      if (key == 'd') { scalar_xheight -= step; } 
      if (key == 'r') { scalar_caps += step; } 
      if (key == 'f') { scalar_caps -= step; } 
      print_scalars();
      draw_text();
    }
}

void draw_text() 
{
    // white background
    background(255, 255, 255);

    // black letters
    fill(0);
    textSize(LETTER_SIZE);
    text("Pjxfpg", 50, baseline);

    // lines
    stroke(0, 255, 0);
    float ascent = baseline - ascent();
    float caps = baseline - caps();
    float xheight = baseline - xheight();
    float descent = baseline + descent();
    line(0, baseline, 500, baseline);
    line(0, ascent, CANVAS_WIDTH, ascent);
    line(0, caps, CANVAS_WIDTH, caps);
    line(0, xheight, CANVAS_WIDTH, xheight);
    line(0, descent, CANVAS_WIDTH, descent);

    textSize(10);
    text("baseline", 600, baseline);
    text("ascent", 600, ascent);
    text("caps", 600, caps);
    text("xheight", 600, xheight);
    text("descent", 600, descent);
}

float ascent()
{
    return scalar_ascent * textAscent();
}

float descent()
{
    return scalar_descent * textDescent();
}

float xheight()
{
    return scalar_xheight * textAscent();
}

float caps()
{
    return scalar_caps * textAscent();
}

void print_scalars()
{
    println("ascent: " + scalar_ascent + " caps: " + scalar_caps + " xheight: " + scalar_xheight + " descent: " + scalar_descent);
}