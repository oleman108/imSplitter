#tag Class
Protected Class imSplitter
Inherits Canvas
	#tag CompatibilityFlags = TargetHasGUI
	#tag Event
		Sub DoubleClick(X As Integer, Y As Integer)
		  If Me.IsDocked Then 
		    If DoubleClickAction > 0 Then 
		      Undock
		    End If
		  End If
		  
		  Select Case DoubleClickAction
		  Case 0  // None
		    
		  Case 1  // DockBack
		    Dock(True)
		    
		  Case 2  // DockAfter
		    Dock(False)
		    
		  End Select
		  
		  DoubleClick(X,Y)
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  Me.lastX = System.MouseX
		  Me.lastY = System.MouseY
		  
		  If MouseDown(X,Y) Then
		    
		  End If
		  
		  Return True
		  
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseDrag(X As Integer, Y As Integer)
		  MoveSplitter
		  MouseDrag(X,Y)
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(X As Integer, Y As Integer)
		  // If splitter is not already docked, then:
		  // Check if splitter is in docking range
		  // See: DockBeforeSize, DockAfterSize
		  
		  MouseUp(X, Y)
		  
		  If Me.IsDocked = False Then
		    
		    If Me.IsHorizontalSplitter Then
		      If Me.Top < Me.DockBeforeSize Then
		        Dock(True)
		        Return
		      End If
		      
		      Dim ParentHeight As Integer = Me.Window.Height
		      If Me.Top > (ParentHeight - DockAfterSize) Then
		        Dock(False)
		        Return
		      End If
		      
		    Else
		      If Me.Left < Me.DockBeforeSize Then
		        Dock(True)
		        Return
		      End If
		      
		      Dim ParentWidth As Integer = Me.Window.Width
		      If Me.Left > (ParentWidth - DockAfterSize) Then
		        Dock(False)
		        Return
		      End If
		      
		    End If
		  End If
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  If Me.Width > Me.Height Then
		    Me.MouseCursor = System.Cursors.SplitterNorthSouth
		    Me.IsHorizontalSplitter = True
		    
		  Else
		    Me.MouseCursor = System.Cursors.SplitterEastWest
		    Me.IsHorizontalSplitter = False
		    
		  End If
		  
		  // Keep Track of Splitterdocking position
		  mIsDockedPosition = imSplitterIs.UnDocked
		  
		  Open
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  If Me.HasBackColor Then
		    g.ForeColor=Me.BackColor
		    g.FillRect(0,0,Me.Width,Me.Height)
		  End If
		  
		  If Me.DrawHandles Then
		    // Draw a circle as splitter handle
		    Dim size As Integer = 20
		    Dim dist As Integer = 2
		    Dim x1,x2,y1,y2 As Integer = 0
		    
		    If Me.IsHorizontalSplitter And Me.Height >= 10 Then
		      x1 = (Me.Width/2)-(size/2)
		      x2 = x1+ size
		      y1 = (Me.Height/2)
		      y2 = y1
		      
		      g.DrawLine(x1,y1-dist,x2,y2-dist)
		      g.DrawLine(x1,y1,x2,y2)
		      g.DrawLine(x1,y1+dist,x2,y2+dist)
		      
		      // vertical splitter
		    Elseif Me.IsHorizontalSplitter=False And Me.Width >= 10 Then  
		      x1 = (Me.Width/2)
		      x2 = x1
		      y1 = (Me.Height/2)-(size/2)
		      y2 = y1 + size
		      
		      g.DrawLine(x1-dist,y1,x2-dist,y2)
		      g.DrawLine(x1,y1,x2,y2)
		      g.DrawLine(x1+dist,y1,x2+dist,y2)
		      
		    End If
		  End If
		  
		  Paint(g)
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddControl(ctrl As ContainerControl, beforeSplitter As Boolean)
		  If beforeSplitter Then  // Left or above splitter
		    CtrlArrayBefore.Append ctrl
		  Else
		    CtrlArrayAfter.Append ctrl
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddControl(ctrl As Control, beforeSplitter As Boolean)
		  // TODO: Check if the control is already there...
		  
		  If beforeSplitter Then  // Left or above splitter
		    CtrlArrayBefore.Append ctrl
		  Else
		    CtrlArrayAfter.Append ctrl
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddControlNoResize(ctrl As ContainerControl, beforeSplitter As Boolean)
		  If beforeSplitter Then  // Left or above splitter
		    CtrlArrayBeforeNoResize.Append ctrl
		  Else
		    CtrlArrayAfterNoResize.Append ctrl
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddControlNoResize(ctrl As Control, beforeSplitter As Boolean)
		  // TODO: Check if the control is already there...
		  
		  If beforeSplitter Then  // Left or above splitter
		    CtrlArrayBeforeNoResize.Append ctrl
		  Else
		    CtrlArrayAfterNoResize.Append ctrl
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AdjustControlsAfter(dx As Integer, dy As Integer)
		  // ***************************************************************
		  // RESIZE CONTROLS and/or ContainerControls which are
		  // added on the RIGHT of vertical splitter
		  // or BELOW of horizontal splitter
		  
		  Dim i As Integer
		  
		  For i = 0 To UBound(CtrlArrayAfter)
		    If IsHorizontalSplitter Then
		      
		      If Me.CtrlArrayAfter(i) IsA RectControl Then
		        RectControl(CtrlArrayAfter(i)).Top = RectControl(CtrlArrayAfter(i)).Top + dy
		        RectControl(CtrlArrayAfter(i)).Height = RectControl(CtrlArrayAfter(i)).Height - dy
		        
		      Else
		        ContainerControl(CtrlArrayAfter(i)).Top = ContainerControl(CtrlArrayAfter(i)).Top + dy
		        ContainerControl(CtrlArrayAfter(i)).Height = ContainerControl(CtrlArrayAfter(i)).Height - dy
		        
		      End If
		      
		    Else // If Vertical splitter
		      
		      If Me.CtrlArrayAfter(i) IsA RectControl Then
		        RectControl(CtrlArrayAfter(i)).Left = RectControl(CtrlArrayAfter(i)).Left + dx
		        RectControl(CtrlArrayAfter(i)).Width = RectControl(CtrlArrayAfter(i)).Width - dx
		        
		      Else
		        ContainerControl(CtrlArrayAfter(i)).Left = ContainerControl(CtrlArrayAfter(i)).Left + dx
		        ContainerControl(CtrlArrayAfter(i)).Width = ContainerControl(CtrlArrayAfter(i)).Width - dx
		        
		      End If
		      
		    End If
		  Next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AdjustControlsAfterNoResize(dx As Integer, dy As Integer)
		  // ***************************************************************
		  // REPOSITION CONTROLS and/or ContainerControls which are
		  // added on the RIGHT of vertical splitter
		  // or BELOW of horizontal splitter
		  
		  Dim i As Integer
		  
		  For i = 0 To UBound(CtrlArrayAfterNoResize)
		    If Me.IsHorizontalSplitter Then
		      
		      If Me.CtrlArrayAfterNoResize(i) IsA RectControl Then
		        RectControl(CtrlArrayAfterNoResize(i)).Top = RectControl(CtrlArrayAfterNoResize(i)).Top + dy
		        
		      Else
		        ContainerControl(CtrlArrayAfterNoResize(i)).Top = ContainerControl(CtrlArrayAfterNoResize(i)).Top + dy
		        
		      End If
		      
		    Else // If Vertical splitter
		      
		      If Me.CtrlArrayAfterNoResize(i) IsA RectControl Then
		        RectControl(CtrlArrayAfterNoResize(i)).Left = RectControl(CtrlArrayAfterNoResize(i)).Left + dx
		        
		      Else
		        ContainerControl(CtrlArrayAfterNoResize(i)).Left = ContainerControl(CtrlArrayAfterNoResize(i)).Left + dx
		      End If
		      
		    End If
		  Next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AdjustControlsBefore(dx As Integer, dy As Integer)
		  // ***************************************************************
		  // RESIZE CONTROLS and/or ContainerControls which are
		  // added on the LEFT of vertical splitter
		  // or ABOVE of horizontal splitter
		  // ***************************************************************
		  
		  Dim i As Integer
		  
		  For i = 0 To UBound(CtrlArrayBefore)
		    If IsHorizontalSplitter Then
		      
		      If Me.CtrlArrayBefore(i) IsA RectControl Then
		        RectControl(CtrlArrayBefore(i)).Height = RectControl(CtrlArrayBefore(i)).Height + dy
		        
		      Else
		        ContainerControl(CtrlArrayBefore(i)).Height = ContainerControl(CtrlArrayBefore(i)).Height + dy
		        
		      End If
		      
		    Else // If Vertical splitter
		      
		      If Me.CtrlArrayBefore(i) IsA RectControl Then
		        RectControl(CtrlArrayBefore(i)).Width = RectControl(CtrlArrayBefore(i)).Width + dx
		        
		      Else
		        ContainerControl(CtrlArrayBefore(i)).Width = ContainerControl(CtrlArrayBefore(i)).Width + dx
		        
		      End If
		      
		    End If
		  Next
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AdjustControlsBeforeNoResize(dx As Integer, dy As Integer)
		  Dim i As Integer
		  
		  // ***************************************************************
		  // REPOSITION CONTROLS and/or ContainerControls which are
		  // added on the LEFT of vertical splitter
		  // or on TOP of horizontal splitter
		  
		  For i = 0 To UBound(CtrlArrayBeforeNoResize)
		    If IsHorizontalSplitter Then
		      
		      If Me.CtrlArrayBeforeNoResize(i) IsA RectControl Then
		        RectControl(CtrlArrayBeforeNoResize(i)).Top = RectControl(CtrlArrayBeforeNoResize(i)).Top + dy
		        
		      Elseif Me.CtrlArrayBeforeNoResize(i) IsA ContainerControl Then
		        ContainerControl(CtrlArrayBeforeNoResize(i)).Top = ContainerControl(CtrlArrayBeforeNoResize(i)).Top + dy
		      End If
		      
		    Else // Is Vertical splitter
		      
		      If Me.CtrlArrayBeforeNoResize(i) IsA RectControl Then
		        RectControl(Me.CtrlArrayBeforeNoResize(i)).Left = RectControl(CtrlArrayBeforeNoResize(i)).Left + dx
		        
		      Elseif Me.CtrlArrayBeforeNoResize(i) IsA ContainerControl Then
		        ContainerControl(CtrlArrayBeforeNoResize(i)).Left = ContainerControl(CtrlArrayBeforeNoResize(i)).Left + dx
		      End If
		      
		    End If
		  Next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Dock(before As Boolean)
		  // Use this method to dock the Splitter from a code.
		  // Parameters: before
		  //    If set to true then it will dock to before of the splitter
		  //    (top or left depending on orientation), if set to false then
		  //    it will dock to after (bottom or right depending on orientation).
		  
		  // Remarks:
		  // The splitter will not dock unless it is correctly configured
		  // to dock in the requested direction.
		  // See the DockAfter,DockAfterSize, DockBefore and DockBeforeSize
		  // properties to correctly set the Splitter to dock.
		  
		  If Me.IsDocked Then
		    Return // Already docked, stop here
		  End If
		  
		  // Save Splitter distance to edge of Window, for restore when undocking
		  If Me.IsHorizontalSplitter Then
		    If before Then
		      // calculate distance of splitter to top of window
		      Me.PositionBeforeDock = - (Me.Top - Me.Window.Height)
		    Else
		      // calculate distance of splitter to bottom of window
		      Me.PositionBeforeDock = Me.Window.Height - Me.Top - Me.Height
		    End If
		  Else
		    If before Then
		      // calculate distance of splitter to left side of window
		      Me.PositionBeforeDock = Me.Left
		    Else
		      // calculate distance of splitter to right side of window
		      Me.PositionBeforeDock = Me.Window.Width - Me.Left
		    End If  // before
		  End If  // Me.IsHorizontalSplitter
		  
		  // *****************************************************
		  Dim moveX As Integer = 0
		  Dim moveY As Integer = 0
		  
		  Select Case before
		  Case True  // DockBack (to Left or Top)
		    If Me.IsHorizontalSplitter Then
		      // Calculate y
		      moveY = -( Me.Top-Me.MinBeforeArea)
		    Else
		      // Vertical splitter, calculate X
		      moveX = -(Me.Left-Me.MinBeforeArea)
		    End If
		    MoveSplitter(moveX,moveY)
		    
		  Case False  // DockAfter (to Right or Bottom)
		    If Me.IsHorizontalSplitter Then
		      // Calculate y
		      moveY = (Me.Window.Height - Me.MinAfterArea) - Me.Top - Me.Height
		      
		    Else
		      // Vertical splitter, calculate X
		      moveX = (Me.Window.Width - Me.MinAfterArea) - Me.Left - Me.Width
		      
		    End If
		    
		    MoveSplitter(moveX,moveY)
		    
		  End Select
		  
		  // Keep track of Docked status
		  Me.mIsDocked = True
		  
		  // Keep Track of Splitterdocking position
		  If before Then
		    mIsDockedPosition = imSplitterIs.DockedBefore
		  Else
		    mIsDockedPosition = imSplitterIs.DockedAfter
		  End If
		  
		  // Raise docked event handler
		  Docked(before)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveSplitter(MoveX As Integer = 0, MoveY As Integer = 0)
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
		  // ================================================================
		  
		  // Initialize variables
		  Dim dx As Integer = MoveX
		  Dim dy As Integer = MoveY
		  Dim mx As Integer = System.MouseX
		  Dim my As Integer = System.MouseY
		  Dim t,l As Integer
		  
		  // If no paramter values were received, then
		  // calculate number of pixels to move the splitter
		  If MoveX = 0 Then dx = -lastX + mx
		  If MoveY = 0 Then dy = -lastY + my
		  
		  // The MouseDrag event fires contiuously and gets queued up.
		  // Try exiting here if the mouse did not move
		  If dx = 0 And dy = 0 Then Return
		  
		  // Determine the width and Height of the Splitter's parent
		  Dim ParentWidth, ParentHeight As Integer
		  ParentWidth = Me.Window.Width
		  ParentHeight = Me.Window.Height
		  
		  // Determine the maximum position value up to where this splitter can be moved.
		  // The minimum Value is already determined in property MinBeforeArea.
		  Dim maxAfter As Integer
		  
		  // *****************************************************************
		  // Note: IsHorizontalSplitter is set in Open event. There we decide 
		  // from the initial dimensions of the splitter whether we treat it 
		  // as a horizontal or vertical splitter.
		  // *****************************************************************
		  
		  If Me.IsHorizontalSplitter Then
		    maxAfter = ParentHeight - MinAfterArea
		    t = Me.Top + dy
		    
		    // Check if we moved the splitter beyond Min or Max edges
		    If t < MinBeforeArea Then
		      Return
		    Elseif t > maxAfter Then
		      Return
		    End If
		    
		    Me.Top = t
		    SplitterMoved(Me.Left, Me.Top)
		    
		  Else
		    maxAfter = ParentWidth - MinAfterArea
		    l = Me.Left + dx
		    
		    // Check if we moved the splitter beyond Min or Max edges
		    If l < MinBeforeArea Then
		      Return
		    Elseif l > maxAfter Then
		      Return
		    End If
		    
		    Me.Left = l
		    SplitterMoved(Me.Left, Me.Top)
		    
		  End If
		  
		  // Store current Mouse position
		  lastx = System.Mousex
		  lasty = System.Mousey
		  
		  // Check whether the splitter
		  // is draged out of a docked position
		  //   If yes, then set undocked
		  If Me.mIsDocked Then 
		    
		    // Reset IsDocked property
		    Me.mIsDocked = False
		    
		    // Raise Undocked EventHandler
		    Select Case IsDockedPosition
		    Case imSplitterIs.DockedBefore
		      Undocked(True)
		      
		    Case imSplitterIs.DockedAfter
		      Undocked(False)
		      
		    End Select
		    
		    // Keep Track of Splitterdocking position
		    mIsDockedPosition = imSplitterIs.UnDocked
		    
		  End If
		  
		  // Now reposition controls which were added to this splitter
		  AdjustControlsBefore(dx, dy)
		  AdjustControlsBeforeNoResize(dx, dy)
		  AdjustControlsAfter(dx, dy)
		  AdjustControlsAfterNoResize(dx, dy)
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveControl(ctrl As ContainerControl)
		  Dim  ctrlFound As Boolean = False
		  Dim  CtrlArray() As Object
		  
		  For i As Integer = 0 To UBound(CtrlArrayAfter)
		    If Me.CtrlArrayAfter(i) IsA ContainerControl Then
		      If ContainerControl(CtrlArrayAfter(i)) = ctrl Then
		        ctrlFound = True
		      Else
		        CtrlArray.Append Me.CtrlArrayAfter(i)
		      End If
		    Else  // Append RectControl
		      CtrlArray.Append Me.CtrlArrayAfter(i)
		    End If
		  Next
		  
		  If ctrlFound Then  // Copy the remaining elements back to original array
		    Redim CtrlArrayAfter(-1)
		    For i As Integer = 0 To UBound(CtrlArray)
		      CtrlArrayAfter.Append CtrlArray(i)
		    Next
		    
		  Else
		    ReDim CtrlArray(-1)
		    
		    For i As Integer = 0 To UBound(CtrlArrayBefore)
		      If Me.CtrlArrayBefore(i) IsA ContainerControl Then
		        If ContainerControl(CtrlArrayBefore(i)) = ctrl Then
		          ctrlFound = True
		        Else
		          CtrlArray.Append Me.CtrlArrayBefore(i)
		        End If
		      Else  // Append RectControl
		        CtrlArray.Append Me.CtrlArrayBefore(i)
		      End If
		    Next
		    
		    If ctrlFound Then  // Copy the remaining elements back to original array
		      Redim CtrlArrayBefore(-1)
		      For i As Integer = 0 To UBound(CtrlArray)
		        CtrlArrayBefore.Append CtrlArray(i)
		      Next
		    End If
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveControl(ctrl As Control)
		  Dim  ctrlFound As Boolean = False
		  Dim  CtrlArray() As Object
		  
		  For i As Integer = 0 To UBound(CtrlArrayAfter)
		    If Me.CtrlArrayAfter(i) IsA RectControl Then
		      If RectControl(CtrlArrayAfter(i)) = RectControl(ctrl) Then
		        ctrlFound = True
		      Else
		        CtrlArray.Append Me.CtrlArrayAfter(i)
		      End If
		    Else  // Append ContainerControls
		      CtrlArray.Append Me.CtrlArrayAfter(i)
		    End If
		  Next
		  
		  If ctrlFound Then  // Copy the remaining elements back to original array
		    Redim CtrlArrayAfter(-1)
		    For i As Integer = 0 To UBound(CtrlArray)
		      CtrlArrayAfter.Append CtrlArray(i)
		    Next
		    
		  Else
		    ReDim CtrlArray(-1)
		    
		    For i As Integer = 0 To UBound(CtrlArrayBefore)
		      If Me.CtrlArrayBefore(i) IsA RectControl Then
		        If RectControl(CtrlArrayBefore(i)) = RectControl(ctrl) Then
		          ctrlFound = True
		        Else
		          CtrlArray.Append Me.CtrlArrayBefore(i)
		        End If
		      Else  // Append ContainerControls
		        CtrlArray.Append Me.CtrlArrayBefore(i)
		      End If
		    Next
		    
		    If ctrlFound Then  // Copy the remaining elements back to original array
		      Redim CtrlArrayBefore(-1)
		      For i As Integer = 0 To UBound(CtrlArray)
		        CtrlArrayBefore.Append CtrlArray(i)
		      Next
		    End If
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Undock()
		  // Undock only if we are docked
		  If Me.IsDocked Then
		    Dim before As Boolean = False
		    Dim moveX As Integer = 0
		    Dim moveY As Integer = 0
		    Dim UndockSize As Integer = 150
		    
		    UndockSize = If(UndockSize > Me.PositionBeforeDock, UndockSize,Me.PositionBeforeDock)
		    
		    If Me.IsHorizontalSplitter Then
		      If IsDockedPosition = imSplitterIs.DockedBefore Then
		        // Undock from top
		        before = True
		        moveY = UndockSize
		        
		      Elseif IsDockedPosition = imSplitterIs.DockedAfter Then
		        // Undock from bottom
		        before = False
		        moveY = -(UndockSize)
		      End If
		      
		    Else // Is Vertical Splitter
		      If IsDockedPosition = imSplitterIs.DockedBefore Then
		        // Undock from Left
		        before = True
		        moveX = UndockSize
		        
		      Elseif IsDockedPosition = imSplitterIs.DockedAfter Then
		        // Undock from Right
		        before = False
		        moveX = -(UndockSize)
		        
		      End If  // IsDockedPosition = imSplitterIs.DockedBefore
		    End If  // Me.IsHorizontalSplitter
		    
		    
		    // Move Splitter
		    MoveSplitter(moveX,moveY)
		    
		    // Keep track of Docked status
		    Me.mIsDocked = False
		    
		    // Keep Track of Splitterdocking position
		    mIsDockedPosition = imSplitterIs.UnDocked
		    
		    // Raise Undocked event handler
		    Undocked(before)
		    
		  End If  // Me.IsDocked
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Docked(before As Boolean)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event DoubleClick(X As Integer, Y As Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseDown(X As Integer, Y As Integer) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseDrag(X As Integer, Y As Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseUp(X As Integer, Y As Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Open()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Paint(g As Graphics)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event SplitterMoved(X As Integer, Y As Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Undocked(before As Boolean)
	#tag EndHook


	#tag Note, Name = ReadMe
		QuickStart:
		
		- Drag imSplitter.obj to your projects folder
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
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mBackColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mBackColor = value
			End Set
		#tag EndSetter
		BackColor As Color
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private CtrlArrayAfter() As Object
	#tag EndProperty

	#tag Property, Flags = &h21
		Private CtrlArrayAfterNoResize() As Object
	#tag EndProperty

	#tag Property, Flags = &h21
		Private CtrlArrayBefore() As Object
	#tag EndProperty

	#tag Property, Flags = &h21
		Private CtrlArrayBeforeNoResize() As Object
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Setting this property to true will make the WindowSplitter 
			dock after the splitter (dock to bottom or right 
			depending on if its a horizontal or vertical splitter).
			
			Remarks
			At what point it will dock can be defined with the DockAfterSize property.
			
			
		#tag EndNote
		DockAfter As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Setting this property will define where 
			docking bellow or after the splitter shall happen.
			
			Remarks
			This property has effect only when the DockAfter property is set to true.
			
			Notes:
			The MinAfterArea and MinBeforeArea properties define the boundaries 
			from the edge of the parent window that the splitter should move. 
			
			The DockSize properties define where docking 
			will occur from the edge if the movement area.
			
		#tag EndNote
		DockAfterSize As Integer = 40
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Setting this property to true will make the WindowSplitter 
			dock before the splitter (dock to top or left depending 
			on whether it is a horizontal or vertical splitter).
			
			Remarks
			At what point it will dock can be defined 
			with the DockBeforeSize property.
			
		#tag EndNote
		DockBefore As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Setting this property will define where docking 
			over or before the splitter shall happen
			
			This property has effect only when the DockBefore property is set to true.
			
			Notes:
			The MinAfterArea and MinBeforeArea properties define the boundaries 
			from the edge of the parent window that the splitter should move. 
			
			The DockSize properties define where docking will occur 
			from the edge if the movement area
		#tag EndNote
		DockBeforeSize As Integer = 40
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			0 None
			1 DockBack
			2 DockAfter
		#tag EndNote
		DoubleClickAction As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		DrawHandles As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		HasBackColor As Boolean = False
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // Use this property to query if the Splitter is docked.
			  // Returns true if the splitter is docked.
			  
			  return mIsDocked
			End Get
		#tag EndGetter
		IsDocked As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mIsDockedPosition
			End Get
		#tag EndGetter
		IsDockedPosition As imSplitterIs
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private IsHorizontalSplitter As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private lastX As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private lastY As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBackColor As Color = &cC0C0C0
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			This property is used to specify the minimum size 
			of the view that comes after the WindowSplitter.
			
			
		#tag EndNote
		MinAfterArea As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			This property is used to specify the minimum size 
			of the view that comes before the WindowSplitter.
			
			
		#tag EndNote
		MinBeforeArea As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsDocked As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsDockedPosition As imSplitterIs
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPositionBeforeDock As Integer = 100
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mPositionBeforeDock
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mPositionBeforeDock = value
			End Set
		#tag EndSetter
		PositionBeforeDock As Integer
	#tag EndComputedProperty


	#tag Enum, Name = imSplitterIs, Type = Integer, Flags = &h0
		DockedBefore
		  DockedAfter
		UnDocked
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="AcceptFocus"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AcceptTabs"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BackColor"
			Visible=true
			Group="Appearance"
			InitialValue="&c000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=true
			Group="Appearance"
			Type="Picture"
			EditorType="Picture"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DockAfter"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DockAfterSize"
			Visible=true
			Group="Behavior"
			InitialValue="40"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DockBefore"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DockBeforeSize"
			Visible=true
			Group="Behavior"
			InitialValue="40"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DoubleBuffer"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DoubleClickAction"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType="Enum"
			#tag EnumValues
				"0 - None"
				"1 - DockBack"
				"2 - DockAfter"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="DrawHandles"
			Visible=true
			Group="Appearance"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EraseBackground"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasBackColor"
			Visible=true
			Group="Appearance"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="200"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpTag"
			Visible=true
			Group="Appearance"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Group="Initial State"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsDocked"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinAfterArea"
			Visible=true
			Group="Position"
			InitialValue="20"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinBeforeArea"
			Visible=true
			Group="Position"
			InitialValue="30"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PositionBeforeDock"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseFocusRing"
			Group="Appearance"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="10"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
