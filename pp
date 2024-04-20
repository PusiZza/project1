#include <SFML/Graphics.hpp>
#include <SFML/Audio.hpp>
#include <vector>
#include <Windows.h>
#include <random>

using namespace sf;
using namespace std;

struct Position
{
    bool free;
    bool entity_аigure;
    short color;
};


class Figure
{
public:
    short color;
    struct Cell
    {
        bool active;
        short cell_coordinate_x;
        short cell_coordinate_y;
    };
    vector<vector<Cell>> type;

    void Type_figure(short type);
    void Square_of_figure(short size);
    bool Check(const vector<vector<Position>>& field, const vector<vector<Cell>>& buffer);
    void To_the_field(vector<vector<Position>>& field, vector<vector<Cell>>& buffer);
    bool Down(vector<vector<Position>>& field, Clock& clock, RenderWindow& Window, vector<short>& nums, bool &pocket_free, int& lin, int& lev, float& coef, bool& slowing_down);
    void Left(vector<vector<Position>>& field);
    void Right(vector<vector<Position>>& field);
    void Upheaval(vector<vector<Position>>& field, bool clockwise);
    bool New_figure(vector<vector<Position>>& field, vector<short>& nums, bool delete_figure, int& lin, int& lev, float& coef);
    bool New_figure(vector<vector<Position>>& field, vector<short>& nums);
    void Ten_in_row(vector<vector<Position>>& field, int& lines, int& level, float& coefficient_speed);
};

void Figure::Type_figure(short type)
{
    this->color = type;
    switch (type)
    {
    case 1:
        Square_of_figure(3);
        this->type[0][0].active = true;
        this->type[1][0].active = true;
        this->type[1][1].active = true;
        this->type[1][2].active = true;
        break;
    case 2:
        Square_of_figure(3);
        this->type[0][1].active = true;
        this->type[1][0].active = true;
        this->type[1][1].active = true;
        this->type[1][2].active = true;
        break;
    case 3:
        Square_of_figure(3);
        this->type[0][2].active = true;
        this->type[1][0].active = true;
        this->type[1][1].active = true;
        this->type[1][2].active = true;
        break;
    case 4:
        Square_of_figure(3);
        this->type[0][1].active = true;
        this->type[0][2].active = true;
        this->type[1][0].active = true;
        this->type[1][1].active = true;
        break;
    case 5:
        Square_of_figure(3);
        this->type[0][0].active = true;
        this->type[0][1].active = true;
        this->type[1][1].active = true;
        this->type[1][2].active = true;
        break;
    case 6:
        Square_of_figure(4);
        this->type[1][0].active = true;
        this->type[1][1].active = true;
        this->type[1][2].active = true;
        this->type[1][3].active = true;
        break;
    case 7:
        Square_of_figure(2);
        this->type[0][0].active = true;
        this->type[0][1].active = true;
        this->type[1][0].active = true;
        this->type[1][1].active = true;
        break;
    default:
        break;
    }
}

void Figure::Square_of_figure(short size)
{
    for (short i = 0; i < size; i++)
    {
        int shift = 0;
        if (size >= 4)
        {
            shift = size - 3;
        }
        type.push_back(vector <Cell>());
        for (short j = 0; j < size; j++)
        {
            short result_y = 20 - 1 - i + shift;
            short result_x = ((10 - 1) / 2) - (size - 1 - (size / 2)) + j;
            type[i].push_back({ false, result_x, result_y });
        }
    }
}

bool Figure::Check(const vector<vector<Position>>& field, const vector<vector<Cell>>& buffer)
{
    for (short i = 0; i < buffer.size(); i++)
    {
        for (short j = 0; j < buffer.size(); j++)
        {
            if (buffer[i][j].active)
            {
                if (buffer[i][j].cell_coordinate_y < 0 || buffer[i][j].cell_coordinate_x >= 10 || buffer[i][j].cell_coordinate_x < 0)
                {
                    return false;
                }
                if (buffer[i][j].cell_coordinate_y < 20 && !field[buffer[i][j].cell_coordinate_y][buffer[i][j].cell_coordinate_x].free)
                {
                    return false;
                }
            }
        }
    }
    return true;
}

void Figure::To_the_field(vector<vector<Position>>& field, vector<vector<Cell>>& buffer)
{
    for (short i = 0; i < buffer.size(); i++)
    {
        for (short j = 0; j < buffer.size(); j++)
        {
            if (type[i][j].cell_coordinate_y < 20 && type[i][j].active)
            {
                field[type[i][j].cell_coordinate_y][type[i][j].cell_coordinate_x].entity_аigure = true;
            }
            type[i][j].cell_coordinate_x = buffer[i][j].cell_coordinate_x;
            type[i][j].cell_coordinate_y = buffer[i][j].cell_coordinate_y;
        }
    }
    for (short i = 0; i < buffer.size(); i++)
    {
        for (short j = 0; j < buffer.size(); j++)
        {
            if (type[i][j].cell_coordinate_y < 20 && type[i][j].active)
            {
                field[type[i][j].cell_coordinate_y][type[i][j].cell_coordinate_x].entity_аigure = false;
                field[type[i][j].cell_coordinate_y][type[i][j].cell_coordinate_x].color = color;
            }
        }
    }
}

bool Figure::Down(vector<vector<Position>>& field, Clock& clock, RenderWindow& Window, vector<short>& nums, bool& pocket_free, int& lin, int& lev, float& coef, bool& slowing_down)
{
    vector<vector<Cell>> buffer = type;
    for (short i = 0; i < type.size(); i++)
    {
        for (short j = 0; j < type.size(); j++)
        {
            buffer[i][j].cell_coordinate_y--;
        }
    }
    if (Check(field, buffer))
    {
        To_the_field(field, buffer);
    }
    else
    {
        if (!New_figure(field, nums, true, lin, lev, coef))
        {
            Window.close();
        }
        clock.restart();
        pocket_free = true;
        slowing_down = false;
        return false;
    }
    for (short i = 0; i < type.size(); i++)
    {
        for (short j = 0; j < type.size(); j++)
        {
            buffer[i][j].cell_coordinate_y--;
        }
    }
    if (!Check(field, buffer))
    {
        slowing_down = true;
    }
    return true;
}

void Figure::Left(vector<vector<Position>>& field)
{
    vector<vector<Cell>> buffer = type;
    for (short i = 0; i < type.size(); i++)
    {
        for (short j = 0; j < type.size(); j++)
        {
            buffer[i][j].cell_coordinate_x--;
        }
    }
    if (Check(field, buffer))
    {
        To_the_field(field, buffer);
    }
}

void Figure::Right(vector<vector<Position>>& field)
{
    vector<vector<Cell>> buffer = type;
    for (short i = 0; i < type.size(); i++)
    {
        for (short j = 0; j < type.size(); j++)
        {
            buffer[i][j].cell_coordinate_x++;
        }
    }
    if (Check(field, buffer))
    {
        To_the_field(field, buffer);
    }
}

void Figure::Upheaval(vector<vector<Position>>& field, bool clockwise)
{
    short row, col;
    vector<vector<Cell>> buffer;
    short min_x = 20, max_x = -10;
    for (short i = 0; i < type.size(); i++)
    {
        buffer.push_back(vector <Cell>());
        for (short j = 0; j < type.size(); j++)
        {
            if (clockwise)
            {
                row = j;
                col = type.size() - 1 - i;
            }
            else
            {
                row = type.size() - 1 - j;
                col = i;
            }
            buffer[i].push_back({ type[i][j].active, type[row][col].cell_coordinate_x, type[row][col].cell_coordinate_y });
            if (buffer[i][j].active)
            {
                if (min_x > buffer[i][j].cell_coordinate_x)
                {
                    min_x = buffer[i][j].cell_coordinate_x;
                }
                if (max_x < buffer[i][j].cell_coordinate_x)
                {
                    max_x = buffer[i][j].cell_coordinate_x;
                }
            }
        }
    }
    short shift = 0;
    if (min_x < 0)
    {
        shift = min_x * (-1);
    }
    else if (max_x >= 10)
    {
        shift = (max_x - (10 - 1)) * (-1);
    }
    for (short i = 0; i < type.size(); i++)
    {
        for (short j = 0; j < type.size(); j++)
        {
            buffer[i][j].cell_coordinate_x += shift;
        }
    }
    if (Check(field, buffer))
    {
        To_the_field(field, buffer);
    }
}

bool Figure::New_figure(vector<vector<Position>>& field, vector<short>& nums, bool delete_figure, int& lin, int& lev, float& coef)
{
    for (short i = 0; i < type.size(); i++)
    {
        for (short j = 0; j < type.size(); j++)
        {
            if (type[i][j].active && type[i][j].cell_coordinate_y < 20)
            {
                field[type[i][j].cell_coordinate_y][type[i][j].cell_coordinate_x].entity_аigure = true;
                if (delete_figure)
                {
                    field[type[i][j].cell_coordinate_y][type[i][j].cell_coordinate_x].free = false;
                }
            }
        }
    }
    if (delete_figure)
    {
        Ten_in_row(field, lin, lev, coef);
    }
    type.clear();
    Type_figure(nums[0]);
    if (Check(field, type))
    {
        To_the_field(field, type);
    }
    else
    {
        return false;
    }
    nums.erase(nums.begin() + 0);
    return true;
}

bool Figure::New_figure(vector<vector<Position>>& field, vector<short>& nums)
{
    Type_figure(nums[0]);
    To_the_field(field, type);
    nums.erase(nums.begin() + 0);
    return true;
}

void Figure::Ten_in_row(vector<vector<Position>>& field, int& lines, int& level, float& coefficient_speed)
{
    for (short i = 0; i < field.size(); i++)
    {
        short in_row = 0;
        for (short j = 0; j < field[0].size(); j++)
        {
            if (!field[i][j].free)
            {
                in_row++;
            }
        }
        if (in_row == 10)
        {
            for (short t = i; t < field.size(); t++)
            {
                for (short h = 0; h < field[0].size(); h++)
                {
                    if (t != 19)
                    {
                        field[t][h].free = field[t + 1][h].free;
                        field[t][h].entity_аigure = field[t + 1][h].entity_аigure;
                        field[t][h].color = field[t + 1][h].color;
                    }
                    else
                    {
                        field[t][h].free = true;
                        field[t][h].entity_аigure = true;
                        field[t][h].color = 0;
                    }
                }
            }
            lines++;
            if (lines % 10 == 0)
            {
                level++;
                coefficient_speed *= 0.84;
            }
            i--;
        }
    }
}

void Check_button(Keyboard::Key key, Clock& clock1, Clock& clock3, int& delay, bool& clamped, bool& clamped2, Figure& figure, vector < vector <Position> >&field, int& speed_down, float koff, bool& hard_drop, bool& soft_drop, Sound& sound)
{
    Time elapsed3 = clock3.getElapsedTime();
    if (clamped)
    {
        if (elapsed3.asMicroseconds() > 200000 * koff)
        {
            delay = 40000;
        }
        else
        {
            delay = 200000 * koff;
        }
    }
    else
    {
        delay = 0;
    }
    Time elapsed1 = clock1.getElapsedTime();
    if (Keyboard::isKeyPressed(key))
    {
        if (elapsed1.asMicroseconds() > delay)
        {

            switch (key)
            {
            case Keyboard::Z:
                figure.Upheaval(field, false);
                break;
            case Keyboard::Up:
                figure.Upheaval(field, true);
                break;
            case Keyboard::Left:
                figure.Left(field);
                break;
            case Keyboard::Right:
                figure.Right(field);
                break;
            case Keyboard::Down:
                soft_drop = true;
                break;
            case Keyboard::Space:
                hard_drop = true;
                sound.play();
                break;
            default:
                break;
            }
            clock1.restart();
        }
        else
        {
            soft_drop = false;
        }

        if (!clamped)
        {
            clamped2 = true;
        }
        else
        {
            clamped2 = false;
        }
        clamped = true;
    }
    else
    {
        clamped2 = false;
        clamped = false;
    }

    if (clamped2)
    {
        clock3.restart();
    }
}

void zeroing_out(bool& x1, bool& x2, bool& x3, bool& x4, bool& x5, bool& x6, Clock& c1, Clock& c2, int& d, bool& cl1, bool& cl2)
{
    x1 = true;
    x2 = false;
    x3 = false;
    x4 = false;
    x5 = false;
    x6 = false;
    d = 0;
    cl1 = false;
    cl2 = false;
    c1.restart();
    c2.restart();
}

void generate_shape_order(vector<short>& nums)
{
    vector<short> nums_2 = { 1, 2, 3, 4, 5, 6, 7};
    shuffle(nums_2.begin(), nums_2.end(), mt19937(random_device()()));
    for (short i = 0; i < 7; i++)
    {
        nums.push_back(nums_2[i]);
    }
}

short main()
{
    Sprite rectangle[20][10];
    Sprite rectangle2[4][4];
    Sprite rectangle3[4][4];

    Vector2f resolution;
    resolution.x = 680;
    resolution.y = 880;

    RenderWindow Window;
    Window.create(VideoMode(resolution.x, resolution.y), "Tetris");

    Sprite BackgroundSprite;
    Texture BackgroundTexture;
    Texture BackgroundTexture3;

    BackgroundTexture.loadFromFile("background2.jpg");
    BackgroundTexture3.loadFromFile("background3.jpg");
    BackgroundSprite.setTexture(BackgroundTexture);

    Sprite ScoreboardSprite;
    Texture ScoreboardTexture;

    ScoreboardTexture.loadFromFile("Scoreboard.jpg");
    ScoreboardSprite.setTexture(ScoreboardTexture);
    ScoreboardSprite.move(480, 0);

    Texture blue, purple, orange, green, red, light_blue, yellow, transparent;
    blue.loadFromFile("Blue.png");
    purple.loadFromFile("Purple.png");
    orange.loadFromFile("Orange.png");
    green.loadFromFile("Green.png");
    red.loadFromFile("Red.png");
    light_blue.loadFromFile("Light blue.png");
    yellow.loadFromFile("Yellow.png");
    transparent.loadFromFile("Transparent.png");

    SoundBuffer buffer;
    buffer.loadFromFile("hard drop.wav");
    Sound sound;
    sound.setBuffer(buffer);

    Music music;
    music.openFromFile("Music.wav");
    music.setLoop(true);

    for (short i = 0; i < 20; i++)
    {
        for (short j = 0; j < 10; j++)
        {
            rectangle[i][j].move(j * 40 + 40, 800 - 40 + 40 - i * 40);
        }
    }

    for (short i = 0; i < 4; i++)
    {
        for (short j = 0; j < 4; j++)
        {
            rectangle2[i][j].move(j * 40 + 500, i * 40 + 190);
        }
    }

    for (short i = 0; i < 4; i++)
    {
        for (short j = 0; j < 4; j++)
        {
            rectangle3[i][j].move(j * 40 + 500, i * 40 + 400);
        }
    }

    const short field_height = 20;
    const short field_length = 10;
    vector < vector <Position> > field;
    for (short i = 0; i < field_height; i++)
    {
        field.push_back(vector <Position>());
        for (short j = 0; j < field_length; j++)
        {
            field[i].push_back({ true, true,  0 });
        }
    }

    vector<short> nums = { 1, 2, 3, 4, 5, 6, 7 };
    shuffle(nums.begin(), nums.end(), mt19937(random_device()()));

    Figure figure;
    figure.New_figure(field, nums);

    Clock clock;
    Clock clock1;
    Clock clock2;
    Clock clock3;

    int speed_down = 10810810;
    float coefficient_speed = 1;
    bool clamped = false;
    bool clamped2 = false;
    bool clamped3 = false;
    int delay = 0;
    bool last_Z = false;
    bool last_Up = false;
    bool last_Left = false;
    bool last_Right = false;
    bool last_Down = false;
    bool last_Space = false;
    bool hard_drop = false;
    bool soft_drop = false;
    bool slowing_down = false;
    short pocket = 0;
    bool pocket_free = true;
    int points = 0;
    int lines = 0;
    int level = 0;
    Font font;
    font.loadFromFile("Times New Roman.ttf");
    string s1, s2, s3;
    Text text1, text2, text3;
    text1.setFont(font);
    text2.setFont(font);
    text3.setFont(font);
    text1.setCharacterSize(20);
    text2.setCharacterSize(20);
    text3.setCharacterSize(20);
    text1.setFillColor(Color(255, 255, 255));
    text2.setFillColor(Color(255, 255, 255));
    text3.setFillColor(Color(255, 255, 255));
    text1.setStyle(Text::Bold);
    text2.setStyle(Text::Bold);
    text3.setStyle(Text::Bold);
    text1.move(595, 582);
    text2.move(595, 638);
    text3.move(595, 696);

    music.play();
    while (Window.isOpen())
    {
        if (nums.size() < 9)
        {
            generate_shape_order(nums);
        }
        Event event;
        while (Window.pollEvent(event))
        {
            if (event.type == Event::Closed)
            {
                Window.close();
            }
            if (event.type == Event::KeyPressed)
            {
                if (event.key.code == Keyboard::Q)
                {
                    if (BackgroundSprite.getTexture() == &BackgroundTexture)
                    {
                        BackgroundSprite.setTexture(BackgroundTexture3);
                    }
                    else
                    {
                        BackgroundSprite.setTexture(BackgroundTexture);
                    }
                }
                if (event.key.code == Keyboard::Z && !last_Z)
                {
                    zeroing_out(last_Z, last_Up, last_Left, last_Right, last_Down, last_Space, clock1, clock3, delay, clamped, clamped2);
                }
                if (event.key.code == Keyboard::Up && !last_Up)
                {
                    zeroing_out(last_Up, last_Z, last_Left, last_Right, last_Down, last_Space, clock1, clock3, delay, clamped, clamped2);
                }
                if (event.key.code == Keyboard::Left && !last_Left)
                {
                    zeroing_out(last_Left, last_Up, last_Z, last_Right, last_Down, last_Space, clock1, clock3, delay, clamped, clamped2);
                }
                if (event.key.code == Keyboard::Right && !last_Right)
                {
                    zeroing_out(last_Right, last_Up, last_Z, last_Left, last_Down, last_Space, clock1, clock3, delay, clamped, clamped2);
                }
                if (event.key.code == Keyboard::Down && !last_Down)
                {
                    zeroing_out(last_Down, last_Up, last_Z, last_Left, last_Right, last_Space, clock1, clock3, delay, clamped, clamped2);
                }
                if (event.key.code == Keyboard::Space && !last_Space)
                {
                    zeroing_out(last_Space, last_Up, last_Z, last_Left, last_Right, last_Down, clock1, clock3, delay, clamped, clamped2);
                }
                if ((event.key.code == Keyboard::LShift || event.key.code == Keyboard::RShift) && pocket_free)
                {
                    if (pocket != 0)
                    {
                        nums.insert(nums.begin(), pocket);
                    }
                    pocket = figure.color;
                    figure.New_figure(field, nums, false, lines, level, coefficient_speed);
                    clock.restart();
                    pocket_free = false;
                }
            }
        }
        if (Keyboard::isKeyPressed(Keyboard::Escape))
        {
            Window.close();
        }
        if (last_Z)
        {
            Check_button(Keyboard::Z, clock1, clock3, delay, clamped, clamped2, figure, field, speed_down, 3, hard_drop, soft_drop, sound);
        }
        else if (last_Up)
        {
            Check_button(Keyboard::Up, clock1, clock3, delay, clamped, clamped2, figure, field, speed_down, 3, hard_drop, soft_drop, sound);
        }
        else if (last_Left)
        {
            Check_button(Keyboard::Left, clock1, clock3, delay, clamped, clamped2, figure, field, speed_down, 1, hard_drop, soft_drop, sound);
        }
        else if (last_Right)
        {
            Check_button(Keyboard::Right, clock1, clock3, delay, clamped, clamped2, figure, field, speed_down, 1, hard_drop, soft_drop, sound);
        }
        else if (last_Down)
        {
            Check_button(Keyboard::Down, clock1, clock3, delay, clamped, clamped2, figure, field, speed_down, 2.5   , hard_drop, soft_drop, sound);
        }
        else if (last_Space)
        {
            Check_button(Keyboard::Space, clock1, clock3, delay, clamped, clamped2, figure, field, speed_down, 2.5, hard_drop, soft_drop, sound);
        }

        if (hard_drop)
        {
            speed_down = 0;
        }
        else if (soft_drop)
        {
            speed_down = 25000;
        }
        else
        {
            speed_down = 1081081;
        }

        Time elapsed = clock.getElapsedTime();
        if (elapsed.asMicroseconds() > speed_down * coefficient_speed || (slowing_down && elapsed.asMicroseconds() > 300000))
        {
            if (!figure.Down(field, clock2, Window, nums, pocket_free, lines, level, coefficient_speed, slowing_down))
            {
                hard_drop = false;
            }
            clock.restart();
        }


        for (short i = 0; i < field_height; i++)
        {
            for (short j = 0; j < field_length; j++)
            {
                if (!field[i][j].free || !field[i][j].entity_аigure)
                {
                    switch (field[i][j].color)
                    {
                    case 1:
                        rectangle[i][j].setTexture(blue);
                        break;
                    case 2:
                        rectangle[i][j].setTexture(purple);
                        break;
                    case 3:
                        rectangle[i][j].setTexture(orange);
                        break;
                    case 4:
                        rectangle[i][j].setTexture(green);
                        break;
                    case 5:
                        rectangle[i][j].setTexture(red);
                        break;
                    case 6:
                        rectangle[i][j].setTexture(light_blue);
                        break;
                    case 7:
                        rectangle[i][j].setTexture(yellow);
                        break;
                    default:
                        break;
                    }
                }
            }
        }
        for (int i = 0; i < 4; i++)
        {
            for (int j = 0; j < 4; j++)
            {
                rectangle2[i][j].setTexture(transparent);
                rectangle3[i][j].setTexture(transparent);
            }
        }
        switch (nums[0])
        {
        case 1:
            rectangle2[1][0].setTexture(blue);
            rectangle2[2][0].setTexture(blue);
            rectangle2[2][1].setTexture(blue);
            rectangle2[2][2].setTexture(blue);
            break;
        case 2:
            rectangle2[1][1].setTexture(purple);
            rectangle2[2][0].setTexture(purple);
            rectangle2[2][1].setTexture(purple);
            rectangle2[2][2].setTexture(purple);
            break;
        case 3:
            rectangle2[1][2].setTexture(orange);
            rectangle2[2][0].setTexture(orange);
            rectangle2[2][1].setTexture(orange);
            rectangle2[2][2].setTexture(orange);
            break;
        case 4:
            rectangle2[1][1].setTexture(green);
            rectangle2[1][2].setTexture(green);
            rectangle2[2][0].setTexture(green);
            rectangle2[2][1].setTexture(green);
            break;
        case 5:
            rectangle2[1][0].setTexture(red);
            rectangle2[1][1].setTexture(red);
            rectangle2[2][1].setTexture(red);
            rectangle2[2][2].setTexture(red);
            break;
        case 6:
            rectangle2[1][0].setTexture(light_blue);
            rectangle2[1][1].setTexture(light_blue);
            rectangle2[1][2].setTexture(light_blue);
            rectangle2[1][3].setTexture(light_blue);
            break;
        case 7:
            rectangle2[1][1].setTexture(yellow);
            rectangle2[1][2].setTexture(yellow);
            rectangle2[2][1].setTexture(yellow);
            rectangle2[2][2].setTexture(yellow);
            break;
        default:
            break;
        }

        switch (pocket)
        {
        case 1:
            rectangle3[1][0].setTexture(blue);
            rectangle3[2][0].setTexture(blue);
            rectangle3[2][1].setTexture(blue);
            rectangle3[2][2].setTexture(blue);
            break;
        case 2:
            rectangle3[1][1].setTexture(purple);
            rectangle3[2][0].setTexture(purple);
            rectangle3[2][1].setTexture(purple);
            rectangle3[2][2].setTexture(purple);
            break;
        case 3:
            rectangle3[1][2].setTexture(orange);
            rectangle3[2][0].setTexture(orange);
            rectangle3[2][1].setTexture(orange);
            rectangle3[2][2].setTexture(orange);
            break;
        case 4:
            rectangle3[1][1].setTexture(green);
            rectangle3[1][2].setTexture(green);
            rectangle3[2][0].setTexture(green);
            rectangle3[2][1].setTexture(green);
            break;
        case 5:
            rectangle3[1][0].setTexture(red);
            rectangle3[1][1].setTexture(red);
            rectangle3[2][1].setTexture(red);
            rectangle3[2][2].setTexture(red);
            break;
        case 6:
            rectangle3[1][0].setTexture(light_blue);
            rectangle3[1][1].setTexture(light_blue);
            rectangle3[1][2].setTexture(light_blue);
            rectangle3[1][3].setTexture(light_blue);
            break;
        case 7:
            rectangle3[1][1].setTexture(yellow);
            rectangle3[1][2].setTexture(yellow);
            rectangle3[2][1].setTexture(yellow);
            rectangle3[2][2].setTexture(yellow);
            break;
        default:
            break;
        }

        s1 = to_string(points);
        s2 = to_string(lines);
        s3 = to_string(level);
        text1.setString(s1);
        text2.setString(s2);
        text3.setString(s3);

        Window.clear();
        Window.draw(BackgroundSprite);
        Window.draw(ScoreboardSprite);
        Window.draw(text1);
        Window.draw(text2);
        Window.draw(text3);
        for (short i = 0; i < 20; i++)
        {
            for (short j = 0; j < 10; j++)
            {
                if (!field[i][j].free || !field[i][j].entity_аigure)
                {
                    Window.draw(rectangle[i][j]);
                }
            }
        }
        for (short i = 0; i < 4; i++)
        {
            for (short j = 0; j < 4; j++)
            {
                Window.draw(rectangle2[i][j]);
                Window.draw(rectangle3[i][j]);
            }
        }
        Window.display();
    }
    return 0;
}
