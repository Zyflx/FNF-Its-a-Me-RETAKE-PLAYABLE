var oldRatings: Array<Dynamic> = PlayState.ratingStuff;

PlayState.ratingStuff = [
    ['F', 0.2],
	['E', 0.4],
	['D', 0.5],
	['C', 0.6],
	['B', 0.69],
	['A', 0.7],
	['A+', 0.8],
	['S', 0.9],
	['S+', 1],
	['SS+', 1]
];

function onCreatePost():Void {
    for(receptor in strumLineNotes)
        receptor.useRGBShader = false;

    final bg: FlxSprite = new FlxSprite().loadGraphic(Paths.image('healthBarNEW'));
    bg.screenCenter(0x01);
    bg.y = healthBar.y - 6;
    uiGroup.insert(uiGroup.members.indexOf(iconP1), bg);

    scoreTxt.color = 0xFFF42626;
    scoreTxt.size = 15;
    scoreTxt.font = Paths.font('mario2.ttf');

    timeTxt.color = 0xFFF42626;
    timeTxt.size = 22;
    timeTxt.font = Paths.font('mario2.ttf');

    if(cpuControlled) {
        botplayTxt.font = Paths.font('mario2.ttf');
        botplayTxt.size = 25;
        botplayTxt.color = 0xFFF42626;
    }

    timeBar.setColors(0xFFF42626, FlxColor.BLACK);

    for(i in 0...ratingsData.length)
        ratingsData[i].image += '-mm';

    comboGroup.cameras = [camGame];

    game.updateIconsScale = (delta: Float) -> {}
}

function onBeatHit():Void {
    iconP1.scale.set(1.1, 1.1);
    iconP2.scale.set(1.1, 1.1);
    iconP1.updateHitbox();
    iconP2.updateHitbox();

    final duration: Float = (0.5 * (1 / (Conductor.bpm / 60))) / playbackRate;
    FlxTween.tween(iconP1.scale, {x: 1, y: 1}, duration, {ease: FlxEase.cubeOut});
    FlxTween.tween(iconP2.scale, {x: 1, y: 1}, duration, {ease: FlxEase.cubeOut});
}

function onUpdateScore():Void {
    scoreTxt.text = songHits == 0 ? 'Score: ' + songScore + '      Misses: ' + songMisses + '      Rating: ?'
    : 'Score: ' + songScore + '      Misses: ' + songMisses + '      Rating: ' + ratingName + ' (' + FlxMath.roundDecimal(ratingPercent * 100, 0) + '%)';
}

function onSpawnNote(note: Note):Void {
    note.rgbShader.enabled = false;
}

function onDestroy():Void {
    PlayState.ratingStuff = oldRatings;
}