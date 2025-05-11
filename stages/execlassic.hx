import objects.BGSprite;
import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormat;

final dir: String = 'stage/';
final stage: Array<BGSprite> = [];
final authorGroup = [];

var gameZoom: Float = 0.015;
var hudZoom: Float = 0.03;
var interval: Int = 0;

var canShake: Bool = false;
var shakeIntensity: Float = 3.5;

var zoomTween: FlxTween;

final outlineShader: FlxRuntimeShader = new FlxRuntimeShader(Paths.getTextFromFile('shaders/outline.frag'));
outlineShader.setBool('enabled', false);
outlineShader.setFloatArray('outlineColor', [244 / 255, 38 / 255, 38 / 255]);

final backCastle: BGSprite = new BGSprite(dir + 'Castillo fondo de hasta atras', -1000, -850, 0.45, 0.45);
addBehindGF(backCastle);

final floor: BGSprite = new BGSprite(dir + 'Suelo y brillo atmosferico', -1000, -850);
addBehindGF(floor);

final fence: BGSprite = new BGSprite(dir + 'Arboles y sombra', -1000, -850);
addBehindGF(fence);

final bricks: BGSprite = new BGSprite(dir + 'CLadrillosPapus', -1000, -850);
add(bricks);

for(stageObject in [backCastle, floor, fence])
    stage.push(stageObject);

FlxG.cameras.remove(camHUD, false);
FlxG.cameras.remove(camOther, false);

final camBackHUD: FlxCamera = new FlxCamera();
camBackHUD.bgColor = FlxColor.TRANSPARENT;

FlxG.cameras.add(camBackHUD, false);
FlxG.cameras.add(camHUD, false);
FlxG.cameras.add(camOther, false);

final overlay: BGSprite = new BGSprite(dir + 'dark');
overlay.screenCenter();
overlay.cameras = [camBackHUD];
add(overlay);

final black: FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
black.scale.set(FlxG.width, FlxG.height);
black.updateHitbox();
black.active = false;
black.cameras = [camOther];
add(black);

// AUTHOR TEXT //
final title: FlxText = new FlxText(400, 304.5, 0, 'It\'s a Me', 42);
title.setFormat(Paths.font('mariones.ttf'), 42, FlxColor.BLACK, 'center', FlxTextBorderStyle.OUTLINE, 0xFFF42626);
title.borderSize = 3;
title.screenCenter(0x01);
title.active = false;
add(title);

final format: FlxTextFormat = new FlxTextFormat(0x000000, false, false, 0xFFF42626);
format.leading = -5;

final author: FlxText = new FlxText(title.x, title.y + 70, 0, 'Raul', 35);
author.setFormat(Paths.font('mariones.ttf'), 35, FlxColor.BLACK, 'center', FlxTextBorderStyle.OUTLINE, 0xFFF42626);
author.active = false;
author.borderSize = 3;
author.screenCenter(0x01);
add(author);
author.addFormat(format);

final width: Float = title.width >= author.width ? title.width : author.width;

final secondLine: FlxSprite = new FlxSprite(566, title.y + 57).makeGraphic(Std.int(width), 5, FlxColor.BLACK);
secondLine.active = false;
secondLine.screenCenter(0x01);

final firstLine: FlxSprite = new FlxSprite(secondLine.x - 5, secondLine.y - 2).makeGraphic(Std.int(width + 10), 8, 0xFFF42626);
firstLine.active = false;
firstLine.screenCenter(0x01);

add(firstLine);
add(secondLine);

for(obj in [title, author, firstLine, secondLine]) {
    obj.alpha = 0.001;
    obj.cameras = [camBackHUD];
    authorGroup.push(obj);
}

///////////////////

game.skipCountdown = true;
game.cameraSpeed = 1.2;
camHUD.alpha = game.camZoomingMult = 0.0;

game.addCharacterToList('mariohorrorpissed', 1);

function onCreatePost():Void {
    gf.scrollFactor.set(1, 1);
    boyfriend.shader = gf.shader = dad.shader = outlineShader;
}

function onUpdatePost(delta: Float):Void {
    final speed: Float = Math.exp(-delta * 9.0 * playbackRate);
    camGame.zoom = FlxMath.lerp(defaultCamZoom, camGame.zoom, speed);
    camHUD.zoom = FlxMath.lerp(1.0, camHUD.zoom, speed);
    camHUD.setPosition(canShake ? FlxG.random.float(-shakeIntensity, shakeIntensity) : 0, canShake ? FlxG.random.float(-shakeIntensity, shakeIntensity) : 0);
}

function onBeatHit():Void {
    if(interval == 0) return;
    if(curBeat % interval == 0)
        game.triggerEvent('Add Camera Zoom', gameZoom + '', hudZoom + '');
}

function onMoveCamera(t: String):Void {
    camFollow.setPosition(t == 'dad' ? 400 : 1020, t == 'dad' ? 350 : 500);
}

function onEvent(name: String, v1: String, v2: String):Void {
    switch(name) {
        case 'Set Cam Zoom':
            game.defaultCamZoom = Std.parseFloat(v1);
        case 'Insta Zoom':
            final zoom: Float = Std.parseFloat(v1);
            game.defaultCamZoom = camGame.zoom = zoom;
        case 'Camera Flash':
            final camera: FlxCamera = switch(StringTools.trim(v1).toLowerCase()) {
                case 'game', 'camgame': camBackHUD;
                case 'hud', 'camhud': camHUD;
            }

            final colorDur: Array<String> = v2.split(',');

            final color: Int = switch(StringTools.trim(colorDur[0]).toLowerCase()) {
                case 'white': FlxColor.WHITE;
                case 'red': 0xFFF42626;
            }

            camera.flash(color, Std.parseFloat(StringTools.trim(colorDur[1])) / playbackRate);
        case 'Song Intro':
            final part: Int = Std.parseInt(v1);

            switch(part) {
                case 0:
                    camFollow.setPosition(FlxG.width * 0.5 + 100, FlxG.height * 0.5 - 570);
                    camGame.snapToTarget();
                    game.isCameraOnForcedPos = true;

                    FlxTween.tween(black, {alpha: 0.0}, 7 / playbackRate, {startDelay: 0.8 / playbackRate});
                    FlxTween.tween(camFollow, {y: 350}, 10 / playbackRate, {startDelay: 1 / playbackRate, ease: FlxEase.quadInOut});
                case 1:
                    FlxTween.tween(camHUD, {alpha: 1.0}, 0.35 / playbackRate);

                    game.isCameraOnForcedPos = false;
                    game.moveCameraSection();

                    onEvent('Set Cam Zoom', '0.57', '');
            }
        case 'Cam Zoom Interval':
            final zooms: Array<String> = v1.split(',');

            if(zooms.length != 0) {
                gameZoom = Std.parseFloat(StringTools.trim(zooms[0]));
                hudZoom = Std.parseFloat(StringTools.trim(zooms[1]));
            }

            interval = Std.parseInt(v2);
        case 'Author Text':
            final hide: Bool = StringTools.trim(v1) == 'true';
            for(i in authorGroup) {
                if(!hide) FlxTween.tween(i, {y: i.y + 30}, 0.5 / playbackRate, {ease: FlxEase.cubeOut});
                FlxTween.tween(i, {alpha: hide ? 0.0 : 1.0}, 0.5 / playbackRate, {
                    ease: FlxEase.cubeOut,
                    onComplete: _ -> {if(hide) i.y = i.y - 30;}
                });
            }
        case 'Camera Twist':
            FlxTween.tween(camGame, {angle: Std.parseFloat(v1)}, Std.parseFloat(v2) / playbackRate, {ease: FlxEase.cubeInOut, onComplete: _ -> camGame.angle = 0});
        case 'Tween Zoom':
            if(zoomTween != null) zoomTween.cancel();
            zoomTween = FlxTween.tween(game, {defaultCamZoom: Std.parseFloat(v1)}, Std.parseFloat(v2) / playbackRate, {ease: FlxEase.cubeInOut});
        case 'Toggle Outline Section':
            final enabled: Bool = outlineShader.getBool('enabled');
            outlineShader.setBool('enabled', !enabled);
            for(char in [dad, boyfriend]) {
                if(char.shader == null)
                    char.shader = outlineShader;
            }
            // overlay.visible = !overlay.visible;
            for(stageObject in stage) stageObject.visible = !stageObject.visible;
        case 'Toggle HUD Shake':
            canShake = !canShake;
        case 'HUD Fade':
            FlxTween.tween(camHUD, {alpha: Std.parseFloat(v1)}, Std.parseFloat(v2) / playbackRate);
    }
}