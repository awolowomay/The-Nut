	#The two "players" in this code are positive and negative. As such:
		#The active player is stored in "player", which contains either 1 or -1
		#the sign of a piece in the position[row][column] tells who owns that piece (unless it's zero, in that case it's unowned)
	#the absolute value of a "normal" piece is 1, and the absolute value of a king is 2
	# the positive player starts out in the smaller rows (0:2) and negative starts in bigger ones (5:7)
# You may note the functions select(), startgame(), and endgame() are not written yet.
# I don't wanna do anything anything with those functions until we have our GUI/interface figured out,
# other than assuming select() returns a list containing a position, in the form [row, column]

pospieces = 12
negpieces = 12
player = 1  #sign determines who it is
position = [[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0]]

def rowselect():
        for row in range(8):
            brow= ' '
            for column in range(8):
                brow = brow + str(position[row][column])+' '
            print(brow)
        row = raw_input("Row?: ")
                return row;
# not written yet

def colselect():
	column = raw_input("column?: ")
	return column;
# not written yet

def startgame():
# not written yet
    return;

def endgame():
# not written yet
    return;

def isPlayable( row, column ):
	if (((row + column) % 2 == 1) and (row >= 0) and (column >= 0) and (row < 8) and (column < 8)):
		return True;
	else:
		return False;

def sign(x):
	if (x==0):
		return;
	elif (x > 0):
		return 1;
	elif (x < 0):
		return -1;

def initializeBoard():
	for row in range(8):
		for column in range(8):
			if (isPlayable(row,column) and (row != 3) and (row != 4)):
				position[row][column] = sign(3.5-row)

def crown():
	for column in range(8):
		if (position[int(3.5*(player+1))][column] == player):
			position[int(3.5*(player+1))][column] *= 2
	return;

def canJump(row, column):
        if (sign(position[row][column]) == player):
                if (isPlayable(row+2*player, column+2)):
                    if ((sign(position[row+player][column+1]) == (-1*player))
                    and (position[row+2*player][column+2] == 0)):
                        return True;
                if (isPlayable(row+2*player, column-2)):
                    if ((sign(position[row+player][column-1]) == (-1*player))
                    and (position[row+2*player][column-2] == 0)):
                        return True;
                if (abs(position[row][column]) > 1):
                    if (isPlayable(row-2*player, column+2)):
                        if ((sign(position[row-player][column+1]) == (-1*player))
                        and (position[row-2*player][column+2] == 0)):
                            return True;
                    if (isPlayable(row-2*player, column-2)):
                        if ((sign(position[row-player][column-1]) == (-1*player))
                        and (position[row-2*player][column-2] == 0)):
                            return True;
        return False;

def canmove(row, column):
        if (sign(position[int(row)][int(column)]) == player):
                if (isPlayable(int(row)+int(player),int(column)+1)):
                    if (position[int(row)+int(player)][int(column)+1] == 0):
                        return True;
                if (isPlayable(int(row)+int(player), int(column)-1)):
                    if (position[int(row)+int(player)][int(column)-1] == 0):
                        return True;
                if (abs(position[int(row)][int(column)]) > 1):
                    if (isPlayable(int(row)-int(player), int(column)+1)):
                        if (position[int(row)-int(player)][int(column)+1] == 0):
                            return True;
                    if (isPlayable(int(row)-int(player), int(column)-1)):
                        if (position[int(row)-int(player)][int(column)-1] == 0):
                            return True;
        return False;

def checkJump():
	for row in range(8):
		for column in range(8):
			if (canJump(row, column)):
				return True;
	return False;

def canGoThere(rowTo, rowFrom, colTo, colFrom):
	rowsign = sign(rowTo-rowFrom)
	colsign = sign(colTo-colFrom)
	if ((abs(position[rowFrom][colFrom]) <= 1) and (rowsign != player)):
		return False;
	if ((abs(rowTo-rowFrom)==2) and (abs(colTo-colFrom)==2) 
	    and (isPlayable(rowTo,colTo)) and (position[rowTo][colTo]==0)
	    and (sign(position[rowFrom+rowsign][colFrom+colsign])==(-1*player))):
		return True;
	return False;

def jump():
        rf=0
        rt=0
        cf=0
        ct=0
        while (not(canJump(int(rf),int(cf)))):
            print("pick jumper")
            rf = rowselect()
            cf = colselect()
        while (not(canGoThere(int(rt),int(rf),int(ct),int(cf)))):
            print("jump where?")
            rt = rowselect()
            ct = colselect()
        sureness = "filler"
        while (sureness != "yes"): #probably will be changed in GUI
            sureness = raw_input("are you sure?(enter 'yes' or no')") 
            sureness.lower()
            if (sureness == "no"):  
                jump()
        position[int(rt)][int(ct)] = position[int(rf)][int(cf)]
        position[int((int(rf)+int(rt))/2)][int((int(ct)+int(cf))/2)] = 0
        position[int(rf)][int(cf)] = 0
        crown()
        if (checkJump()):
            jump()
        return;

def move():
    rowFrom = 0
    rowTo= 0
    colFrom = 0
    colTo = 0
    while (not(canmove(int(rowFrom),int(colFrom)))):
        print("select mover")
        rowFrom = rowselect()
        colFrom = colselect()
    if (abs(position[int(rowFrom)][int(colFrom)]) > 1):
        while (not((abs(int(rowTo)- int(rowFrom)) == 1) and (abs(int(colTo)-int(colFrom)) == 1)
        and (isPlayable(int(rowTo),int(colTo))) and (position[int(rowTo)][int(colTo)] == 0))):
            print("where to?")
            rowTo = rowselect()
            colTo = colselect()
    else:
        while (not(((int(rowTo)- int(rowFrom)) == player) and (abs(int(colTo)- int(colFrom)) == 1)
        and (isPlayable(int(rowTo),int(colTo))) and (position[int(rowTo)][int(colTo)] == 0))):
            print("where to?")
            rowTo = rowselect()
            colTo = colselect()
    sureness = "filler"
    while (sureness != "yes"): #probably will be changed in GUI
            sureness = raw_input("are you sure? (enter 'yes' or no')") 
            sureness.lower()
            if (sureness == "no"):  
                move()
    position[int(rowTo)][int(colTo)] = position[int(rowFrom)][int(colFrom)]
    position[int(rowFrom)][int(colFrom)] = 0
    return;

def countPieces():
	pospieces = 0
	negpieces = 0
	for row in range(8):
		for column in range(8):
			if (position[row][column] > 0):
				pospieces += 1
			if (position[row][column] < 0):
				negpieces += 1
	return;

# no more function definitions, I'm actually running the game now

#startgame()
initializeBoard()
while ((negpieces != 0) and (pospieces != 0)): #nobody's lost yet
	if (checkJump()):
		jump()
	else:
		move()
	crown()
	countPieces()
	player *= -1  #other guy's turn
#endgame()
