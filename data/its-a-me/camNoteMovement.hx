final extendOffset: Int = 20;
final directions: Array<Array<Int>> = [[-extendOffset, 0], [0, extendOffset], [0, -extendOffset], [extendOffset, 0]];
var returnTimer: FlxTimer;

function opponentNoteHit(note: Note):Void {
    if(PlayState.SONG.notes[curSection].mustHitSection) return;
    camGame.targetOffset.set(directions[note.noteData][0], directions[note.noteData][1]);
    if(returnTimer != null) returnTimer.cancel();
    returnTimer = new FlxTimer().start(Conductor.crochet * 0.001 / playbackRate, _ -> camGame.targetOffset.set(0, 0));
}

function goodNoteHit(note: Note):Void {
    if(!PlayState.SONG.notes[curSection].mustHitSection) return;
    camGame.targetOffset.set(directions[note.noteData][0], directions[note.noteData][1]);
    if(returnTimer != null) returnTimer.cancel();
    returnTimer = new FlxTimer().start(Conductor.crochet * 0.001 / playbackRate, _ -> camGame.targetOffset.set(0, 0));
}