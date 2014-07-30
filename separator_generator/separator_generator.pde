import processing.pdf.*;

// dev mode
boolean DEV_MODE = false;

// utilities for the draw method
int letter_index = 0;
boolean init = true;
boolean same_keypress = false;



float resolution = 72.0; // dpi
float mm2inch = 25.4; // 1 inch = 25.4 mm

// all sizes below given in mm

// board size
int BOARD_WIDTH = 370;
int BOARD_HEIGHT = 180;
// project's parameters
int ALPHABET_OFFSET_X = 130;
int ALPHABET_OFFSET_Y = 40;
int LETTER_SIZE = 16;
int LETTER_SLOT_SIZE = 20;
int FONT_NAME_OFFSET_X = 20;
int FONT_NAME_OFFSET_Y = 40;
int FONT_NAME_MAX_WIDTH = 90;
int FONT_NAME_MAX_HEIGHT = 30;
int FONT_NAME_SIZE = 40;
int AUTHOR_BASELINE = 90;
int DATE_BASELINE = 110;
int MAIN_LETTER_OFFSET_X = 270;
int MAIN_LETTER_OFFSET_Y = 40;
int MAIN_LETTER_MAX_WIDTH = 90;
int MAIN_LETTER_MAX_HEIGHT = 100;
// this sets the degree by which font size are refined
float step = 0.01;

// store all data
ArrayList<Separator> separators;

void setup() {
    if (DEV_MODE) {
        size(int(px(BOARD_WIDTH)), int(px(BOARD_HEIGHT)));
    } else {
        size(int(px(BOARD_WIDTH)), int(px(BOARD_HEIGHT)), PDF, "test.pdf");
    }

    separators = new ArrayList<Separator>();
    separators.add(new Separator("Futura LT Medium", "F", "Paul Renner", "1927", "Futura", 0.83, 0.71, 0.44, 1.20));
    separators.add(new Separator("Georgia", "G", "Matthew Carter", "1993", "Georgia", 0.83, 0.76, 0.53, 0.98));
}

void draw() 
{
    if (!DEV_MODE) {
        PGraphicsPDF pdf = (PGraphicsPDF) g;  // Get the renderer
        Separator sep;
        for (int i = 0; i < separators.size(); i++) {
            sep = this.separators.get(i);
            sep.draw();
            pdf.nextPage();
        }
        exit();
    } else {
        if (init) {
            init = false;
            separators.get(letter_index).draw();
        }

        if (!keyPressed) {
            same_keypress = false;
        }
        if (keyPressed && !same_keypress) {
            same_keypress = true;

            if (key == 'n') { 
                letter_index++;
                if (letter_index >= separators.size()) {
                    letter_index = 0;
                }
            } 
            if (key == 'p') {
                letter_index--;
                if (letter_index < 0) {
                    letter_index = separators.size()-1;
                }
            }
            separators.get(letter_index).draw();
        }
    }
}

class Separator {
    // properties
    PFont font;
    String main_letter, author, year, font_display_name;
    float scalar_ascent, scalar_caps, scalar_xheight, scalar_descent;

    // constructor
    Separator(String font_name, String main_letter, String author, String year, String font_display_name, 
        float scalar_ascent, float scalar_caps, float scalar_xheight, float scalar_descent) 
    {
        // import font into project
        this.font = createFont(font_name, LETTER_SIZE);

        // font properties
        this.scalar_ascent = scalar_ascent;
        this.scalar_caps = scalar_caps;
        this.scalar_xheight = scalar_xheight;
        this.scalar_descent = scalar_descent;

        // content
        this.main_letter = main_letter;
        this.author = author;
        this.year = year;
        this.font_display_name = font_display_name;
    }

    void draw() {
        // white background
        background(255);
        // set font
        textFont(this.font);
        // draw various elements
        this.draw_font_name();

        this.set_text_size(this.author, FONT_NAME_MAX_WIDTH, LETTER_SIZE);
        this.draw_author();
        this.draw_year();
        
        this.draw_alphabet();
        this.draw_main_letter();
    }

    void draw_alphabet()
    {

        this.set_text_size(LETTER_SIZE);
        // draw grid
        stroke(0, 50);
        float x_start = px(ALPHABET_OFFSET_X);
        float x_end = px(ALPHABET_OFFSET_X + 6 * LETTER_SLOT_SIZE);
        float y_baseline, y_xheight, y_ascent, y_descent;
        for (int row = 0; row < 5; row++) {
            y_baseline = px(ALPHABET_OFFSET_Y + row * LETTER_SLOT_SIZE + (LETTER_SLOT_SIZE - LETTER_SIZE) / 2) + this.ascent();
            y_xheight = y_baseline - this.xheight();
            y_ascent = y_baseline - this.ascent();
            y_descent = y_baseline + this.descent();

            // always displayed : baseline and xheight
            line(x_start, y_baseline, x_end, y_baseline);
            line(x_start, y_xheight, x_end, y_xheight);
            // ascent not displayed on row 3
            if (row != 2 && row != 3 && row != 4) {
                line(x_start, y_ascent, x_end, y_ascent);
            }
            // descent not displayed on first row
            if (row != 0 && row !=3) {
                line(x_start, y_descent, x_end, y_descent);
            }
        } 

        // draw letters
        textAlign(CENTER, BASELINE);

        String[] letters = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"};
        textAlign(CENTER, BASELINE);

        for(int i = 0; i < 26; i++) {
            int col = i % 6;
            int row = (i - col) / 6;

            float y = px(ALPHABET_OFFSET_Y + row * LETTER_SLOT_SIZE + (LETTER_SLOT_SIZE - LETTER_SIZE) / 2);
            float baseline = y + this.ascent();

            float x = px(ALPHABET_OFFSET_X + (col + 0.5) * LETTER_SLOT_SIZE);
            // write to canvas
            fill(0);
            text(letters[i], x, baseline);
        }
    }


    void draw_main_letter()
    {
        // main letter
        this.set_caps_size(this.main_letter, MAIN_LETTER_MAX_WIDTH, MAIN_LETTER_MAX_HEIGHT);
        //textMode(SHAPE);
        textAlign(RIGHT, BASELINE);
        noFill();
        stroke(0, 0.5);
        rect(px(MAIN_LETTER_OFFSET_X), px(MAIN_LETTER_OFFSET_Y), px(MAIN_LETTER_MAX_WIDTH), px(MAIN_LETTER_MAX_HEIGHT));
        float y = MAIN_LETTER_OFFSET_Y + MAIN_LETTER_MAX_HEIGHT; // + (MAIN_LETTER_MAX_HEIGHT/2) - (font_size - textAscent());
        fill(0);
        text(this.main_letter, px(MAIN_LETTER_OFFSET_X + MAIN_LETTER_MAX_WIDTH), px(y));

    }

    void draw_font_name()
    {
        fill(0);
        this.set_text_size(this.font_display_name, FONT_NAME_MAX_WIDTH, FONT_NAME_MAX_HEIGHT);
        textAlign(LEFT, BASELINE);
        float x = px(FONT_NAME_OFFSET_X);
        float baseline = px(FONT_NAME_OFFSET_Y) + this.ascent();
        text(this.font_display_name, x, baseline); 
    }

    void draw_author()
    {
        fill(0);
        textAlign(LEFT, BASELINE);
        float x = px(FONT_NAME_OFFSET_X);
        float baseline = px(AUTHOR_BASELINE);
        text(this.author, x, baseline);
    }

    void draw_year()
    {
        fill(0);
        textAlign(LEFT, BASELINE);
        float x = px(FONT_NAME_OFFSET_X);
        float baseline = px(DATE_BASELINE);
        text(this.year, x, baseline);
    }

    /**
     * Set text size so that the full height is equal to max_width
     * max_width in mm
     */
    void set_text_size(float max_height)
    {
        max_height = px(max_height);
        float font_size =  step;
        textSize(font_size);
        while (this.get_text_height() < max_height) {
            font_size += step;
            textSize(font_size);
        }
    }

    void set_text_size(String text, float max_width, float max_height)
    {
        max_width = px(max_width);
        max_height = px(max_height);
        float font_size =  step;
        textSize(font_size);
        while (this.get_text_height() < max_height && textWidth(text) < max_width) {
            font_size += step;
            textSize(font_size);
        }
    }

    /**
     * Set text size so that the caps height is equal to max_height
     * max_width in mm
     */
    void set_caps_size(float max_height)
    {
        max_height = px(max_height);
        float font_size =  step;
        textSize(font_size);
        while (this.caps() < max_height) {
            font_size += step;
            textSize(font_size);
        }
    }

    void set_caps_size(String text, float max_width, float max_height)
    {
        max_width = px(max_width);
        max_height = px(max_height);
        float font_size =  step;
        textSize(font_size);
        while (this.caps() < max_height && textWidth(text) < max_width) {
            font_size += step;
            textSize(font_size);
        }
    }

    float get_text_height()
    {
        return this.descent() + max(this.caps(), this.ascent());
    }

    float descent()
    {
        return this.scalar_descent * textDescent();
    }

    float ascent()
    {
        return this.scalar_ascent * textAscent();
    }

    float caps()
    {
        return this.scalar_caps * textAscent();
    }

    float xheight()
    {
        return this.scalar_xheight * textAscent();
    }
}

// Convert value from mm to px
float px(float x) {
    return x * resolution / mm2inch;
}

