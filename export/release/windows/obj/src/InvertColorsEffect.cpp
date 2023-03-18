#include <hxcpp.h>

#ifndef INCLUDED_Effect
#include <Effect.h>
#endif
#ifndef INCLUDED_InvertColorsEffect
#include <InvertColorsEffect.h>
#endif
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

HX_DEFINE_STACK_FRAME(_hx_pos_cd330a62fd89da64_312_new,"InvertColorsEffect","new",0x5fd46129,"InvertColorsEffect.new","Shaders.hx",312,0x469785f0)

void InvertColorsEffect_obj::__construct(){
            	HX_GC_STACKFRAME(&_hx_pos_cd330a62fd89da64_312_new)
HXDLIN( 312)		this->shader =  ::InvertShader_obj::__alloc( HX_CTX );
            	}

Dynamic InvertColorsEffect_obj::__CreateEmpty() { return new InvertColorsEffect_obj; }

void *InvertColorsEffect_obj::_hx_vtable = 0;

Dynamic InvertColorsEffect_obj::__Create(::hx::DynamicArray inArgs)
{
	::hx::ObjectPtr< InvertColorsEffect_obj > _hx_result = new InvertColorsEffect_obj();
	_hx_result->__construct();
	return _hx_result;
}

bool InvertColorsEffect_obj::_hx_isInstanceOf(int inClassId) {
	if (inClassId<=(int)0x265c7b77) {
		return inClassId==(int)0x00000001 || inClassId==(int)0x265c7b77;
	} else {
		return inClassId==(int)0x5ccf95d5;
	}
}


::hx::ObjectPtr< InvertColorsEffect_obj > InvertColorsEffect_obj::__new() {
	::hx::ObjectPtr< InvertColorsEffect_obj > __this = new InvertColorsEffect_obj();
	__this->__construct();
	return __this;
}

::hx::ObjectPtr< InvertColorsEffect_obj > InvertColorsEffect_obj::__alloc(::hx::Ctx *_hx_ctx) {
	InvertColorsEffect_obj *__this = (InvertColorsEffect_obj*)(::hx::Ctx::alloc(_hx_ctx, sizeof(InvertColorsEffect_obj), true, "InvertColorsEffect"));
	*(void **)__this = InvertColorsEffect_obj::_hx_vtable;
	__this->__construct();
	return __this;
}

InvertColorsEffect_obj::InvertColorsEffect_obj()
{
}

void InvertColorsEffect_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(InvertColorsEffect);
	HX_MARK_MEMBER_NAME(shader,"shader");
	HX_MARK_END_CLASS();
}

void InvertColorsEffect_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(shader,"shader");
}

::hx::Val InvertColorsEffect_obj::__Field(const ::String &inName,::hx::PropertyAccess inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"shader") ) { return ::hx::Val( shader ); }
	}
	return super::__Field(inName,inCallProp);
}

::hx::Val InvertColorsEffect_obj::__SetField(const ::String &inName,const ::hx::Val &inValue,::hx::PropertyAccess inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"shader") ) { shader=inValue.Cast<  ::InvertShader >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void InvertColorsEffect_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_("shader",25,bf,20,1d));
	super::__GetFields(outFields);
};

#ifdef HXCPP_SCRIPTABLE
static ::hx::StorageInfo InvertColorsEffect_obj_sMemberStorageInfo[] = {
	{::hx::fsObject /*  ::InvertShader */ ,(int)offsetof(InvertColorsEffect_obj,shader),HX_("shader",25,bf,20,1d)},
	{ ::hx::fsUnknown, 0, null()}
};
static ::hx::StaticInfo *InvertColorsEffect_obj_sStaticStorageInfo = 0;
#endif

static ::String InvertColorsEffect_obj_sMemberFields[] = {
	HX_("shader",25,bf,20,1d),
	::String(null()) };

::hx::Class InvertColorsEffect_obj::__mClass;

void InvertColorsEffect_obj::__register()
{
	InvertColorsEffect_obj _hx_dummy;
	InvertColorsEffect_obj::_hx_vtable = *(void **)&_hx_dummy;
	::hx::Static(__mClass) = new ::hx::Class_obj();
	__mClass->mName = HX_("InvertColorsEffect",b7,98,98,ce);
	__mClass->mSuper = &super::__SGetClass();
	__mClass->mConstructEmpty = &__CreateEmpty;
	__mClass->mConstructArgs = &__Create;
	__mClass->mGetStaticField = &::hx::Class_obj::GetNoStaticField;
	__mClass->mSetStaticField = &::hx::Class_obj::SetNoStaticField;
	__mClass->mStatics = ::hx::Class_obj::dupFunctions(0 /* sStaticFields */);
	__mClass->mMembers = ::hx::Class_obj::dupFunctions(InvertColorsEffect_obj_sMemberFields);
	__mClass->mCanCast = ::hx::TCanCast< InvertColorsEffect_obj >;
#ifdef HXCPP_SCRIPTABLE
	__mClass->mMemberStorageInfo = InvertColorsEffect_obj_sMemberStorageInfo;
#endif
#ifdef HXCPP_SCRIPTABLE
	__mClass->mStaticStorageInfo = InvertColorsEffect_obj_sStaticStorageInfo;
#endif
	::hx::_hx_RegisterClass(__mClass->mName, __mClass);
}

