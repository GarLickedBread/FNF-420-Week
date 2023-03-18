#include <hxcpp.h>

#ifndef INCLUDED_InvertShader
#include <InvertShader.h>
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

HX_DEFINE_STACK_FRAME(_hx_pos_f1cc1b74057943ec_333_new,"InvertShader","new",0xd6e4156d,"InvertShader.new","Shaders.hx",333,0x469785f0)

void InvertShader_obj::__construct(){
            	HX_STACKFRAME(&_hx_pos_f1cc1b74057943ec_333_new)
HXLINE( 182)		if (::hx::IsNull( this->_hx___glFragmentSource )) {
HXLINE( 184)			this->_hx___glFragmentSource = HX_("\r\n    varying float openfl_Alphav;\n\t\tvarying vec4 openfl_ColorMultiplierv;\n\t\tvarying vec4 openfl_ColorOffsetv;\n\t\tvarying vec2 openfl_TextureCoordv;\n\n\t\tuniform bool openfl_HasColorTransform;\n\t\tuniform vec2 openfl_TextureSize;\n\t\tuniform sampler2D bitmap;\n\n\t\tuniform bool hasTransform;\n\t\tuniform bool hasColorTransform;\n\n\t\tvec4 flixel_texture2D(sampler2D bitmap, vec2 coord)\n\t\t{\n\t\t\tvec4 color = texture2D(bitmap, coord);\n\t\t\tif (!hasTransform)\n\t\t\t{\n\t\t\t\treturn color;\n\t\t\t}\n\n\t\t\tif (color.a == 0.0)\n\t\t\t{\n\t\t\t\treturn vec4(0.0, 0.0, 0.0, 0.0);\n\t\t\t}\n\n\t\t\tif (!hasColorTransform)\n\t\t\t{\n\t\t\t\treturn color * openfl_Alphav;\n\t\t\t}\n\n\t\t\tcolor = vec4(color.rgb / color.a, color.a);\n\n\t\t\tmat4 colorMultiplier = mat4(0);\n\t\t\tcolorMultiplier[0][0] = openfl_ColorMultiplierv.x;\n\t\t\tcolorMultiplier[1][1] = openfl_ColorMultiplierv.y;\n\t\t\tcolorMultiplier[2][2] = openfl_ColorMultiplierv.z;\n\t\t\tcolorMultiplier[3][3] = openfl_ColorMultiplierv.w;\n\n\t\t\tcolor = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);\n\n\t\t\tif (color.a > 0.0)\n\t\t\t{\n\t\t\t\treturn vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);\n\t\t\t}\n\t\t\treturn vec4(0.0, 0.0, 0.0, 0.0);\n\t\t}\n\t\n\r\n\r\n    vec4 sineWave(vec4 pt)\r\n    {\r\n        return vec4(1.0 - pt.x, 1.0 - pt.y, 1.0 - pt.z, pt.w);\r\n    }\r\n\r\n    void main()\r\n    {\r\n        vec2 uv = openfl_TextureCoordv;\r\n        gl_FragColor = sineWave(texture2D(bitmap, uv));\r\n    }",0b,39,80,5e);
            		}
HXLINE( 174)		if (::hx::IsNull( this->_hx___glVertexSource )) {
HXLINE( 176)			this->_hx___glVertexSource = HX_("\n\t\tattribute float openfl_Alpha;\n\t\tattribute vec4 openfl_ColorMultiplier;\n\t\tattribute vec4 openfl_ColorOffset;\n\t\tattribute vec4 openfl_Position;\n\t\tattribute vec2 openfl_TextureCoord;\n\n\t\tvarying float openfl_Alphav;\n\t\tvarying vec4 openfl_ColorMultiplierv;\n\t\tvarying vec4 openfl_ColorOffsetv;\n\t\tvarying vec2 openfl_TextureCoordv;\n\n\t\tuniform mat4 openfl_Matrix;\n\t\tuniform bool openfl_HasColorTransform;\n\t\tuniform vec2 openfl_TextureSize;\n\n\t\t\n\t\tattribute float alpha;\n\t\tattribute vec4 colorMultiplier;\n\t\tattribute vec4 colorOffset;\n\t\tuniform bool hasColorTransform;\n\t\t\n\t\tvoid main(void)\n\t\t{\n\t\t\topenfl_Alphav = openfl_Alpha;\n\t\topenfl_TextureCoordv = openfl_TextureCoord;\n\n\t\tif (openfl_HasColorTransform) {\n\n\t\t\topenfl_ColorMultiplierv = openfl_ColorMultiplier;\n\t\t\topenfl_ColorOffsetv = openfl_ColorOffset / 255.0;\n\n\t\t}\n\n\t\tgl_Position = openfl_Matrix * openfl_Position;\n\n\t\t\t\n\t\t\topenfl_Alphav = openfl_Alpha * alpha;\n\t\t\t\n\t\t\tif (hasColorTransform)\n\t\t\t{\n\t\t\t\topenfl_ColorOffsetv = colorOffset / 255.0;\n\t\t\t\topenfl_ColorMultiplierv = colorMultiplier;\n\t\t\t}\n\t\t}",f3,1e,fa,79);
            		}
HXLINE( 334)		super::__construct();
HXLINE( 316)		this->_hx___isGenerated = true;
HXDLIN( 316)		this->_hx___initGL();
            	}

Dynamic InvertShader_obj::__CreateEmpty() { return new InvertShader_obj; }

void *InvertShader_obj::_hx_vtable = 0;

Dynamic InvertShader_obj::__Create(::hx::DynamicArray inArgs)
{
	::hx::ObjectPtr< InvertShader_obj > _hx_result = new InvertShader_obj();
	_hx_result->__construct();
	return _hx_result;
}

bool InvertShader_obj::_hx_isInstanceOf(int inClassId) {
	if (inClassId<=(int)0x1c6063e7) {
		if (inClassId<=(int)0x04f93fcd) {
			return inClassId==(int)0x00000001 || inClassId==(int)0x04f93fcd;
		} else {
			return inClassId==(int)0x1c6063e7;
		}
	} else {
		return inClassId==(int)0x1efca5b6 || inClassId==(int)0x78d8d737;
	}
}


::hx::ObjectPtr< InvertShader_obj > InvertShader_obj::__new() {
	::hx::ObjectPtr< InvertShader_obj > __this = new InvertShader_obj();
	__this->__construct();
	return __this;
}

::hx::ObjectPtr< InvertShader_obj > InvertShader_obj::__alloc(::hx::Ctx *_hx_ctx) {
	InvertShader_obj *__this = (InvertShader_obj*)(::hx::Ctx::alloc(_hx_ctx, sizeof(InvertShader_obj), true, "InvertShader"));
	*(void **)__this = InvertShader_obj::_hx_vtable;
	__this->__construct();
	return __this;
}

InvertShader_obj::InvertShader_obj()
{
}

#ifdef HXCPP_SCRIPTABLE
static ::hx::StorageInfo *InvertShader_obj_sMemberStorageInfo = 0;
static ::hx::StaticInfo *InvertShader_obj_sStaticStorageInfo = 0;
#endif

::hx::Class InvertShader_obj::__mClass;

void InvertShader_obj::__register()
{
	InvertShader_obj _hx_dummy;
	InvertShader_obj::_hx_vtable = *(void **)&_hx_dummy;
	::hx::Static(__mClass) = new ::hx::Class_obj();
	__mClass->mName = HX_("InvertShader",fb,da,9f,9c);
	__mClass->mSuper = &super::__SGetClass();
	__mClass->mConstructEmpty = &__CreateEmpty;
	__mClass->mConstructArgs = &__Create;
	__mClass->mGetStaticField = &::hx::Class_obj::GetNoStaticField;
	__mClass->mSetStaticField = &::hx::Class_obj::SetNoStaticField;
	__mClass->mStatics = ::hx::Class_obj::dupFunctions(0 /* sStaticFields */);
	__mClass->mMembers = ::hx::Class_obj::dupFunctions(0 /* sMemberFields */);
	__mClass->mCanCast = ::hx::TCanCast< InvertShader_obj >;
#ifdef HXCPP_SCRIPTABLE
	__mClass->mMemberStorageInfo = InvertShader_obj_sMemberStorageInfo;
#endif
#ifdef HXCPP_SCRIPTABLE
	__mClass->mStaticStorageInfo = InvertShader_obj_sStaticStorageInfo;
#endif
	::hx::_hx_RegisterClass(__mClass->mName, __mClass);
}

