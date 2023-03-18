#include <hxcpp.h>

#ifndef INCLUDED_GlitchShader
#include <GlitchShader.h>
#endif
#ifndef INCLUDED_flixel_graphics_tile_FlxGraphicsShader
#include <flixel/graphics/tile/FlxGraphicsShader.h>
#endif
#ifndef INCLUDED_openfl_display_GraphicsShader
#include <openfl/display/GraphicsShader.h>
#endif
#ifndef INCLUDED_openfl_display_Shader
#include <openfl/display/Shader.h>
#endif
#ifndef INCLUDED_openfl_display_ShaderParameter_Float
#include <openfl/display/ShaderParameter_Float.h>
#endif

HX_DEFINE_STACK_FRAME(_hx_pos_f46673645c9c8da3_103_new,"GlitchShader","new",0x6d622f0c,"GlitchShader.new","Shaders.hx",103,0x469785f0)

void GlitchShader_obj::__construct(){
            	HX_STACKFRAME(&_hx_pos_f46673645c9c8da3_103_new)
HXLINE( 182)		if (::hx::IsNull( this->_hx___glFragmentSource )) {
HXLINE( 184)			this->_hx___glFragmentSource = HX_("\r\n    varying float openfl_Alphav;\n\t\tvarying vec4 openfl_ColorMultiplierv;\n\t\tvarying vec4 openfl_ColorOffsetv;\n\t\tvarying vec2 openfl_TextureCoordv;\n\n\t\tuniform bool openfl_HasColorTransform;\n\t\tuniform vec2 openfl_TextureSize;\n\t\tuniform sampler2D bitmap;\n\n\t\tuniform bool hasTransform;\n\t\tuniform bool hasColorTransform;\n\n\t\tvec4 flixel_texture2D(sampler2D bitmap, vec2 coord)\n\t\t{\n\t\t\tvec4 color = texture2D(bitmap, coord);\n\t\t\tif (!hasTransform)\n\t\t\t{\n\t\t\t\treturn color;\n\t\t\t}\n\n\t\t\tif (color.a == 0.0)\n\t\t\t{\n\t\t\t\treturn vec4(0.0, 0.0, 0.0, 0.0);\n\t\t\t}\n\n\t\t\tif (!hasColorTransform)\n\t\t\t{\n\t\t\t\treturn color * openfl_Alphav;\n\t\t\t}\n\n\t\t\tcolor = vec4(color.rgb / color.a, color.a);\n\n\t\t\tmat4 colorMultiplier = mat4(0);\n\t\t\tcolorMultiplier[0][0] = openfl_ColorMultiplierv.x;\n\t\t\tcolorMultiplier[1][1] = openfl_ColorMultiplierv.y;\n\t\t\tcolorMultiplier[2][2] = openfl_ColorMultiplierv.z;\n\t\t\tcolorMultiplier[3][3] = openfl_ColorMultiplierv.w;\n\n\t\t\tcolor = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);\n\n\t\t\tif (color.a > 0.0)\n\t\t\t{\n\t\t\t\treturn vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);\n\t\t\t}\n\t\t\treturn vec4(0.0, 0.0, 0.0, 0.0);\n\t\t}\n\t\n \r\n\r\n    //uniform float tx, ty; // x,y waves phase\r\n\r\n    //modified version of the wave shader to create weird garbled corruption like messes\r\n    uniform float uTime;\r\n    \r\n    /**\r\n     * How fast the waves move over time\r\n     */\r\n    uniform float uSpeed;\r\n    \r\n    /**\r\n     * Number of waves over time\r\n     */\r\n    uniform float uFrequency;\r\n    \r\n    /**\r\n     * How much the pixels are going to stretch over the waves\r\n     */\r\n    uniform float uWaveAmplitude;\r\n\r\n    vec2 sineWave(vec2 pt)\r\n    {\r\n        float x = 0.0;\r\n        float y = 0.0;\r\n        \r\n        float offsetX = sin(pt.y * uFrequency + uTime * uSpeed) * (uWaveAmplitude / pt.x * pt.y);\r\n        float offsetY = sin(pt.x * uFrequency - uTime * uSpeed) * (uWaveAmplitude / pt.y * pt.x);\r\n        pt.x += offsetX; // * (pt.y - 1.0); // <- Uncomment to stop bottom part of the screen from moving\r\n        pt.y += offsetY;\r\n\r\n        return vec2(pt.x + x, pt.y + y);\r\n    }\r\n\r\n    void main()\r\n    {\r\n        vec2 uv = sineWave(openfl_TextureCoordv);\r\n        gl_FragColor = texture2D(bitmap, uv);\r\n    }",df,61,0d,54);
            		}
HXLINE( 174)		if (::hx::IsNull( this->_hx___glVertexSource )) {
HXLINE( 176)			this->_hx___glVertexSource = HX_("\n\t\tattribute float openfl_Alpha;\n\t\tattribute vec4 openfl_ColorMultiplier;\n\t\tattribute vec4 openfl_ColorOffset;\n\t\tattribute vec4 openfl_Position;\n\t\tattribute vec2 openfl_TextureCoord;\n\n\t\tvarying float openfl_Alphav;\n\t\tvarying vec4 openfl_ColorMultiplierv;\n\t\tvarying vec4 openfl_ColorOffsetv;\n\t\tvarying vec2 openfl_TextureCoordv;\n\n\t\tuniform mat4 openfl_Matrix;\n\t\tuniform bool openfl_HasColorTransform;\n\t\tuniform vec2 openfl_TextureSize;\n\n\t\t\n\t\tattribute float alpha;\n\t\tattribute vec4 colorMultiplier;\n\t\tattribute vec4 colorOffset;\n\t\tuniform bool hasColorTransform;\n\t\t\n\t\tvoid main(void)\n\t\t{\n\t\t\topenfl_Alphav = openfl_Alpha;\n\t\topenfl_TextureCoordv = openfl_TextureCoord;\n\n\t\tif (openfl_HasColorTransform) {\n\n\t\t\topenfl_ColorMultiplierv = openfl_ColorMultiplier;\n\t\t\topenfl_ColorOffsetv = openfl_ColorOffset / 255.0;\n\n\t\t}\n\n\t\tgl_Position = openfl_Matrix * openfl_Position;\n\n\t\t\t\n\t\t\topenfl_Alphav = openfl_Alpha * alpha;\n\t\t\t\n\t\t\tif (hasColorTransform)\n\t\t\t{\n\t\t\t\topenfl_ColorOffsetv = colorOffset / 255.0;\n\t\t\t\topenfl_ColorMultiplierv = colorMultiplier;\n\t\t\t}\n\t\t}",f3,1e,fa,79);
            		}
HXLINE( 104)		super::__construct();
HXLINE(  58)		this->_hx___isGenerated = true;
HXDLIN(  58)		this->_hx___initGL();
            	}

Dynamic GlitchShader_obj::__CreateEmpty() { return new GlitchShader_obj; }

void *GlitchShader_obj::_hx_vtable = 0;

Dynamic GlitchShader_obj::__Create(::hx::DynamicArray inArgs)
{
	::hx::ObjectPtr< GlitchShader_obj > _hx_result = new GlitchShader_obj();
	_hx_result->__construct();
	return _hx_result;
}

bool GlitchShader_obj::_hx_isInstanceOf(int inClassId) {
	if (inClassId<=(int)0x1efca5b6) {
		if (inClassId<=(int)0x04f93fcd) {
			return inClassId==(int)0x00000001 || inClassId==(int)0x04f93fcd;
		} else {
			return inClassId==(int)0x1efca5b6;
		}
	} else {
		return inClassId==(int)0x4bac4bda || inClassId==(int)0x78d8d737;
	}
}


::hx::ObjectPtr< GlitchShader_obj > GlitchShader_obj::__new() {
	::hx::ObjectPtr< GlitchShader_obj > __this = new GlitchShader_obj();
	__this->__construct();
	return __this;
}

::hx::ObjectPtr< GlitchShader_obj > GlitchShader_obj::__alloc(::hx::Ctx *_hx_ctx) {
	GlitchShader_obj *__this = (GlitchShader_obj*)(::hx::Ctx::alloc(_hx_ctx, sizeof(GlitchShader_obj), true, "GlitchShader"));
	*(void **)__this = GlitchShader_obj::_hx_vtable;
	__this->__construct();
	return __this;
}

GlitchShader_obj::GlitchShader_obj()
{
}

void GlitchShader_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(GlitchShader);
	HX_MARK_MEMBER_NAME(tx,"tx");
	HX_MARK_MEMBER_NAME(uTime,"uTime");
	HX_MARK_MEMBER_NAME(uSpeed,"uSpeed");
	HX_MARK_MEMBER_NAME(uFrequency,"uFrequency");
	HX_MARK_MEMBER_NAME(uWaveAmplitude,"uWaveAmplitude");
	 ::flixel::graphics::tile::FlxGraphicsShader_obj::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

void GlitchShader_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(tx,"tx");
	HX_VISIT_MEMBER_NAME(uTime,"uTime");
	HX_VISIT_MEMBER_NAME(uSpeed,"uSpeed");
	HX_VISIT_MEMBER_NAME(uFrequency,"uFrequency");
	HX_VISIT_MEMBER_NAME(uWaveAmplitude,"uWaveAmplitude");
	 ::flixel::graphics::tile::FlxGraphicsShader_obj::__Visit(HX_VISIT_ARG);
}

::hx::Val GlitchShader_obj::__Field(const ::String &inName,::hx::PropertyAccess inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"tx") ) { return ::hx::Val( tx ); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"uTime") ) { return ::hx::Val( uTime ); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"uSpeed") ) { return ::hx::Val( uSpeed ); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"uFrequency") ) { return ::hx::Val( uFrequency ); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"uWaveAmplitude") ) { return ::hx::Val( uWaveAmplitude ); }
	}
	return super::__Field(inName,inCallProp);
}

::hx::Val GlitchShader_obj::__SetField(const ::String &inName,const ::hx::Val &inValue,::hx::PropertyAccess inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"tx") ) { tx=inValue.Cast<  ::openfl::display::ShaderParameter_Float >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"uTime") ) { uTime=inValue.Cast<  ::openfl::display::ShaderParameter_Float >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"uSpeed") ) { uSpeed=inValue.Cast<  ::openfl::display::ShaderParameter_Float >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"uFrequency") ) { uFrequency=inValue.Cast<  ::openfl::display::ShaderParameter_Float >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"uWaveAmplitude") ) { uWaveAmplitude=inValue.Cast<  ::openfl::display::ShaderParameter_Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void GlitchShader_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_("tx",84,65,00,00));
	outFields->push(HX_("uTime",22,d7,b7,95));
	outFields->push(HX_("uSpeed",d2,3e,58,dc));
	outFields->push(HX_("uFrequency",67,2b,c6,3f));
	outFields->push(HX_("uWaveAmplitude",95,fa,de,e6));
	super::__GetFields(outFields);
};

#ifdef HXCPP_SCRIPTABLE
static ::hx::StorageInfo GlitchShader_obj_sMemberStorageInfo[] = {
	{::hx::fsObject /*  ::openfl::display::ShaderParameter_Float */ ,(int)offsetof(GlitchShader_obj,tx),HX_("tx",84,65,00,00)},
	{::hx::fsObject /*  ::openfl::display::ShaderParameter_Float */ ,(int)offsetof(GlitchShader_obj,uTime),HX_("uTime",22,d7,b7,95)},
	{::hx::fsObject /*  ::openfl::display::ShaderParameter_Float */ ,(int)offsetof(GlitchShader_obj,uSpeed),HX_("uSpeed",d2,3e,58,dc)},
	{::hx::fsObject /*  ::openfl::display::ShaderParameter_Float */ ,(int)offsetof(GlitchShader_obj,uFrequency),HX_("uFrequency",67,2b,c6,3f)},
	{::hx::fsObject /*  ::openfl::display::ShaderParameter_Float */ ,(int)offsetof(GlitchShader_obj,uWaveAmplitude),HX_("uWaveAmplitude",95,fa,de,e6)},
	{ ::hx::fsUnknown, 0, null()}
};
static ::hx::StaticInfo *GlitchShader_obj_sStaticStorageInfo = 0;
#endif

static ::String GlitchShader_obj_sMemberFields[] = {
	HX_("tx",84,65,00,00),
	HX_("uTime",22,d7,b7,95),
	HX_("uSpeed",d2,3e,58,dc),
	HX_("uFrequency",67,2b,c6,3f),
	HX_("uWaveAmplitude",95,fa,de,e6),
	::String(null()) };

::hx::Class GlitchShader_obj::__mClass;

void GlitchShader_obj::__register()
{
	GlitchShader_obj _hx_dummy;
	GlitchShader_obj::_hx_vtable = *(void **)&_hx_dummy;
	::hx::Static(__mClass) = new ::hx::Class_obj();
	__mClass->mName = HX_("GlitchShader",1a,f9,ca,62);
	__mClass->mSuper = &super::__SGetClass();
	__mClass->mConstructEmpty = &__CreateEmpty;
	__mClass->mConstructArgs = &__Create;
	__mClass->mGetStaticField = &::hx::Class_obj::GetNoStaticField;
	__mClass->mSetStaticField = &::hx::Class_obj::SetNoStaticField;
	__mClass->mStatics = ::hx::Class_obj::dupFunctions(0 /* sStaticFields */);
	__mClass->mMembers = ::hx::Class_obj::dupFunctions(GlitchShader_obj_sMemberFields);
	__mClass->mCanCast = ::hx::TCanCast< GlitchShader_obj >;
#ifdef HXCPP_SCRIPTABLE
	__mClass->mMemberStorageInfo = GlitchShader_obj_sMemberStorageInfo;
#endif
#ifdef HXCPP_SCRIPTABLE
	__mClass->mStaticStorageInfo = GlitchShader_obj_sStaticStorageInfo;
#endif
	::hx::_hx_RegisterClass(__mClass->mName, __mClass);
}

