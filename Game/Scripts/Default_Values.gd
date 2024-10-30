extends Node

#region Piece Speed Limits
# [DEFAULT, MIN, MAX]
const SNAP_SPEED := [30, 20, 35] # Range: 20-35, 30
const DRAG_SPEED := [20, 7, 20] # Range: 7-20, 20
const ZONE_SPEED := [10, 7, 20] # Range: 7-20, 10
const AI_SPEED := [7, 3, 10] # Range: 3-10, 7
#endregion

const ALPHA := 0.25
const DROPZONE_COLOR := Color(Color.MEDIUM_SEA_GREEN, ALPHA)
