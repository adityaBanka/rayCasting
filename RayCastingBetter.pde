int number_of_walls = 10;
Segment walls[] = new Segment[number_of_walls];

int number_of_rays = 720;
float target = 10;
float light_throw_distance_percentage = 0; //percentage terms of diagonal
float light_throw_distance;

boolean rising = true;

int gradient = 150;
int alpha = 2;

PShape illumination;
PShape[] inner = new PShape[gradient];


int counter[] = new int[number_of_rays];
int current_ray = 0;

void setup()
{
    fullScreen();
    // size(960, 540);
    // size(480, 270);
    for (int i = 0; i < number_of_walls; i++)
    {
        walls[i] = new Segment();
    }
    calculateThrowDistance();
    
    for (int i = 0; i < number_of_rays; i++)
    {
        counter[i] = 0;
    }
}

void draw()
{
  // delay(500);
  if(rising == true)
  {
    target ++;
  }
  else{
    target -=2;
  }

  if(target >= 50 )
  {
    // target = 50;
    rising = false;
  }
  else if(target <= 0 && light_throw_distance_percentage < 1)
  {
    light_throw_distance_percentage = 1;
    target = 1;
    rising = true;
    for (int i = 0; i < number_of_walls; i++)
    {
        walls[i] = new Segment();
    }
  }

    
    background(28, 28, 34);

    int size = 10;
    if (light_throw_distance_percentage < target)
    {
        float delta = target - light_throw_distance_percentage;
        // if(delta < size)
        // delta = size ;
        light_throw_distance_percentage += delta / 10.0;
        calculateThrowDistance();
    }
    else if (light_throw_distance_percentage > target)
    {
        float delta = target - light_throw_distance_percentage;
        // if(delta > -size)
        // delta = -size;
        light_throw_distance_percentage += delta / 10.0;
        calculateThrowDistance();
    }
    
    for (int i = 0; i < number_of_walls; i++)
    {
        walls[i].draw();
    }


    
    
    illumination = createShape();
    illumination.beginShape();
    illumination.stroke(255, 255, 0, alpha);
    illumination.strokeWeight(1);
    illumination.fill(255, 255, 0, alpha);
    for (int k = 0; k < gradient; k++)
    {
        inner[k] = createShape();
        inner[k].beginShape();
        inner[k].stroke(255, 255, 0, alpha);
        inner[k].strokeWeight(1);
        inner[k].fill(255, 255, 0, alpha);
    }
    
    
    current_ray = 0;
    for (int i = 0; i < number_of_rays; i++)
    {
        float angle = (2.0 * PI * current_ray) / (number_of_rays);
        // PVector ray_start = new PVector(mouseX, mouseY);
        PVector ray_start = new PVector(width/2, height/2);
        PVector ray_end = PVector.fromAngle(angle);
        ray_end.setMag(light_throw_distance);
        ray_end.add(ray_start);
        
        
        for (int j = 0; j < number_of_walls; j++)
        {
            PVector intersect = getIntersection(ray_start, ray_end, walls[j].start, walls[j].end);
            if (intersect != null)
            {
                ray_end = intersect.copy();
            }
        }
        
        illumination.vertex(ray_end.x, ray_end.y);
        
        
        PVector middle_points[] = new PVector[gradient];
        for (int j = 0; j < gradient; j++)
        {
            middle_points[j] = PVector.fromAngle(angle);
            middle_points[j].setMag(((light_throw_distance * 1.0) / (gradient * 1.0)) * j);
            //middle_points[j].setMag(light_throw_distance/2.0);
            middle_points[j].add(ray_start);
            if (ray_start.dist(ray_end) < ray_start.dist(middle_points[j]))
            {
                middle_points[j] = ray_end.copy();
            }
            inner[j].vertex(middle_points[j].x,middle_points[j].y);
        }
        
        current_ray++;
    }
    illumination.endShape(CLOSE);
    for (int k = 0; k < gradient; k++)
    {
        inner[k].endShape();
        shape(inner[k]);
    }
    shape(illumination);
    saveFrame("images/frame#####.png");
}

PVector getIntersection(PVector p1, PVector p2, PVector p3, PVector p4)
{
    //Using parametric equations forline intersections
    
    float denominator = (p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x);
    if (denominator == 0) 
    {
        return null; // Lines are parallel or coincident
    }
    
    float t = ((p1.x - p3.x) * (p3.y - p4.y) - (p1.y - p3.y) * (p3.x - p4.x)) / denominator;
    float u = -((p1.x - p2.x) * (p1.y - p3.y) - (p1.y - p2.y) * (p1.x - p3.x)) / denominator;
    
    if (t >= 0 && t <= 1 && u >= 0 && u <= 1)
    {
        // There is an intersection
        float x = p1.x + t * (p2.x - p1.x);
        float y = p1.y + t * (p2.y - p1.y);
        return new PVector(x, y);
    }
    
    return null; // No intersection within the line segments
}

void calculateThrowDistance()
{
    light_throw_distance = (light_throw_distance_percentage / 100.0) * (sqrt((width * width) + (height * height)));
}

// void mouseWheel(MouseEvent event)
// {
//     float e = event.getCount();
//     e *= -5;
//     if ((e < 0 && target > 5) || (e > 0 && target <80))
//     {
//         target += e;
//     }
// }

// void mouseClicked()
// {
//     if (mouseButton == LEFT)
//     {
//         if (target!= 0)
//             target = 0;
//         else if (target ==  0)
//             target = 80;
//     }
//     else if (mouseButton == RIGHT)
//         for (int i = 0; i < number_of_walls; i++)
//     {
//         walls[i] = new Segment();
//     }
// }
