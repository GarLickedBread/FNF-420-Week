function onCreate()
	makeLuaSprite('bg','',-900,-900)
	makeGraphic('bg',4000,4000,'ffffff')
	addLuaSprite('bg',false)

	makeAnimatedLuaSprite('transflag','trans/transflag', 0, 0)
	addAnimationByPrefix('transflag','dance','transflag',20,true)
	objectPlayAnimation('transflag','dance',false)
	setScrollFactor('transflag', 1.0, 1.0);
	scaleObject('transflag',1.8,1.6)
	setProperty('transflag.alpha', tonumber(0))
	setBlendMode('transflag', 'add');

	addLuaSprite('transflag',false)
	setObjectCamera('transflag','hud')


	function onBeatHit()
     		doTweenY('tuin', 'camHUD', -angleshit*8, crochet*0.001, 'circOut')
	end

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end