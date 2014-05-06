imSplitter
==========

Canvas based splitter for Xojo desktop builds
From SplitterTest.xojo_project, copy the imSplitter class into your own project.

SubClass imSplitter and use your new, subclassed version of imSplitter in your project.
If you ever have a need for a more powerful splitter, providing more features than
this one, then you can replace it by simply changing its Super to 'WindowSplitter'
of Einhugur.


QuickStart:

- Drag imSplitter.xojo_binary_code to your projects folder (or copy/paste it from the example project)
- From ProjectControls, drag imSplitter to your Window or ContainerControl
- Move it to its position between Controls or ContainerControls and
- Resize it accordingly.
- Set its properties in the property Editor
- In its open eventhandler, use methods
      AddControl(<controlname>,<before>) or
      AddControlNoResize(<controlname>,<before>)


Properties:
===========
HasBackColor As Boolean
    True = Coloring on
    False = Coloring off

Backcolor As Color

DockAfter As Boolean
    True = Docking is on, to right or bottom of Scrollbar

DockBefore As Boolean
    True = Docking is on, to  left or Top of Scrollbar

DockAfterSize As Integer
    Area in Pixel where docking occurs, measured from
    Parent's right or bottom edge

DockBeforeSize As Integer
    Area in Pixel where docking occurs, measured from
    Parent's left or top edge

DoubleClickAction As Integer
    0 None (No docking on Doublecklick)
    1 DockBack (Dock to Left or Top on Doubleclick)
    2 DockAfter (Dock to Right or Bottom, on Doubleclick)
    To be set in properies panel

IsDocked As Boolean (Read Only)
    True = Splitter is in docked position and state

IsDockedPosition As imSplitterIs (Read Only)
    Enumeration:
       imSplitterIs.DockedBefore
       imSplitterIs.DockedAfter
       imSplitterIs.Undocked

MinAfterArea As Integer
    Defines Docking Area:
    Distance measured from the RIGHT or BOTTOM edge of
    the splitter's parent Window or ContainerControl.

    VerticalSplitter:
    When Docking, then Splitter.Left is set to MinAfterArea

    HorizontalSplitter:
    When Docking, then Splitter.Top is set to MinAfterArea


MinBeforeArea As Integer
    Defines Docking Area:
    Distance measured from the LEFT or TOP edge of
    the splitter's parent Window or ContainerControl.

    VerticalSplitter:
    When Docking, then Splitter.Left is set to MinBeforeArea

    HorizontalSplitter:
    When Docking, then Splitter.Top is set to MinBeforeArea



Events:
=======
Docked(before As Boolean)
    Occurs after Splitter was Docked

Undocked(before As Boolean)
    Occurs after Splitter was Undocked

SplitterMoved(X As Integer, Y As Integer)
    Occurs after Splitter has been moved
    X : Splitter.Left value after Splitter was moved
    X : Splitter.Top value after Splitter was moved


Methods:
========
AddControl(ContainerControl, Boolean)
AddControl(Control, Boolean)
AddControlNoResize(ContainerControl, Boolean)
AddControlNoResize(Control, Boolean)

  Parameters: - Name of a Control or ContainerControl Instance
              - before As Boolean
                  True = Object is on the Left or on Top of the Splitter
                  False = Object is on the Right or at the Bottom of the Splitter
  Example:
  In the Open event handler of imSplitter1 we added:
    me.AddControl(Listbox1,True)
    me.AddControl(Listbox2,False)
    me.AddControl(imSplitter2,False)
    me.AddControl(ContainerControl11,False)
    me.AddControlNoResize(Listbox3,False)
    me.AddControlNoResize(imSplitter3,False)
  

Dock(before As Boolean)
  // Use this method to dock the Splitter from code.
  // Parameters: before
  //    If set to true then it will dock to left or top of the splitter 
  //    (top or left depending on orientation), if set to false then 
  //    it will dock to after (bottom or right depending on orientation).
  
  // Remarks: 
  // The splitter will not dock unless it is correctly configured 
  // to dock in the requested direction. 
  // See the DockAfter,DockAfterSize, DockBefore and DockBeforeSize 
  // properties to correctly set the Splitter to dock.
  

MoveSplitter(MoveX As Integer = 0, MoveY As Integer = 0)
  // We can pass optional parameters MoveX and MoveY 
  // to this method when we programaticaly want to move
  // a splitter to a different position.
  //
  // MoveX designates the number of pixels for the splitter to move 
  // to the right (positive) or to the left (negative value)
  // MoveY designates the number of pixels for the splitter to move 
  // downwards (positive) or upwards (negative value) 
  //
  // If we call the method without any parameters, the move is calculated 
  // from the difference between the last mousedown coordinates 
  // (see MouseDown event handler) and the current mouse position 
  // (System.MouseX, ..Y)



Enumerations:
=============
imSplitterIs.DockedBefore
            .DockedAfter
            .Undocked
  

====================================================================
Attention:
There seems to be a bug on Linux 
with TextArea having Scrollbar switched on.
 
When built FOR LINUX, when resizing with this splitter
a TextArea with VerticalScrollbar checked (= on), 
then the app will crash as soon as the textarea is getting to thin.

Workarounds (Linux only): 
- Disable Vertical Scrollbar in TextArea
- Use replacement for TextArea
