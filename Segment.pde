class Segment
{
  PVector start = new PVector();
  PVector end = new PVector();
  
  Segment()
  {
    int per_width = (int)(width*0.1);
    int per_height = (int)(height*0.1);
    
    start.x = random( per_width, width - per_width);
    start.y = random( per_height, height - per_height);
    
    end.x = start.x + random( per_width * 2 );
    end.y = start.y + random( per_height * 2 );
  }
  Segment(PVector start_of_line, PVector end_of_line)
  {
    start = start_of_line;
    end = end_of_line;
  }
  Segment(Segment original)
  {
    start.x = original.start.x;
    start.y = original.start.y;
    end.x = original.end.x;
    end.y = original.end.y;
  }
  
  public void draw()
  {
    stroke(255);
    strokeWeight(5);
    line(start.x, start.y, end.x, end.y);
  }
}
