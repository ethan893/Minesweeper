import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private int NUM_ROWS = 20;
private int NUM_COLS = 20;
int NUM_BOMBA = 50;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>();//ArrayList of just the minesweeper buttons that are mined
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
   
    // make the manager
    Interactive.make( this );
   
    //your code to initialize buttons goes here
    buttons = new MSButton [NUM_ROWS] [NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++) {
      for(int c = 0; c < NUM_COLS; c++) {
        buttons[r][c] = new MSButton(r,c);
      }
    }
   
    setMines();
}
public void setMines()
{
 while(mines.size() < NUM_BOMBA) {
   int r = (int)(Math.random()*20);
    int c = (int)(Math.random()*20);
   if(!mines.contains(buttons[r][c])) {
   mines.add(buttons[r][c]);
   }
 }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    int neverMine = 0;
    for(int i = 0; i < NUM_ROWS; i++)
    for(int j = 0; j < NUM_COLS; j++)
    if(!mines.contains(buttons[i][j]) && buttons[i][j].isClicked())
    neverMine++;
    if(neverMine == 400 - NUM_BOMBA)
    return true;
    else
    return false;
}
public void displayLosingMessage()
{
  String lose = "You lose";
    for(int i = 2; i < lose.length()+2; i++)
    buttons[0][i].setLabel(lose.substring(i-2,i-1));
    for(int a = 0; a < buttons.length; a++) {
    for(int b = 0; b < buttons[a].length; b++) {
    if(!buttons[a][b].isClicked() && mines.contains(buttons[a][b]))
    buttons[a][b].mousePressed();
    }
    }
}
public void displayWinningMessage()
{
 String win = "You win";
    for(int i = 2; i < win.length()+2; i++)
    buttons[0][i].setLabel(win.substring(i-2,i-1));
}
public boolean isValid(int row, int col)
{
   if(row < NUM_ROWS && row >= 0 && col >= 0 && col < NUM_COLS)
  return true;
  return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
     for(int r = row-1;r<=row+1;r++) 
    for(int c = col-1; c<=col+1;c++) 
      if(isValid(r,c) && mines.contains(buttons[r][c]))
        numMines++;
  if(mines.contains(buttons[row][col]))
    numMines--;
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
   
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    public void mousePressed ()
    {
        clicked = true;
        if(mouseButton == RIGHT && flagged == true) {
        flagged = false;
        clicked = false;
        }
        else if(mouseButton == RIGHT && flagged == false)
        flagged = true;
        else if (mines.contains(this))
        displayLosingMessage();
        else if(countMines(myRow,myCol) > 0)
        setLabel(countMines(myRow,myCol));
        else
        for(int i = NUM_ROWS-1; i <= NUM_ROWS+1; i++)
        for(int j = NUM_COLS-1; j <= NUM_COLS+1; j++)
        if(isValid(i+1,j+1) && clicked == false)
        buttons[i+1][j+1].mousePressed();
        
    }
    public void draw ()
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) )
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
