#include <hxcpp.h>

#ifndef INCLUDED_DistortBGEffect
#include <DistortBGEffect.h>
#endif
#ifndef INCLUDED_DistortBGShader
#include <DistortBGShader.h>
#endif
#ifndef INCLUDED_Effect
#include <Effect.h>
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

HX_DEFINE_STACK_FRAME(_hx_pos_e1ea4856156ad031_108_new,"DistortBGEffect","new",0x1f3bb4d3,"DistortBGEffect.new","Shaders.hx",108,0x469785f0)
static const Float _hx_array_data_7fce4f61_1[] = {
	(Float)0,
};
HX_LOCAL_STACK_FRAME(_hx_pos_e1ea4856156ad031_122_update,"DistortBGEffect","update",0x7327ab76,"DistortBGEffect.update","Shaders.hx",122,0x469785f0)
HX_LOCAL_STACK_FRAME(_hx_pos_e1ea4856156ad031_128_set_waveSpeed,"DistortBGEffect","set_waveSpeed",0xc35d0b24,"DistortBGEffect.set_waveSpeed","Shaders.hx",128,0x469785f0)
HX_LOCAL_STACK_FRAME(_hx_pos_e1ea4856156ad031_135_set_waveFrequency,"DistortBGEffect","set_waveFrequency",0xedfc88b9,"DistortBGEffect.set_waveFrequency","Shaders.hx",135,0x469785f0)
HX_LOCAL_STACK_FRAME(_hx_pos_e1ea4856156ad031_142_set_waveAmplitude,"DistortBGEffect","set_waveAmplitude",0x9c0d1b60,"DistortBGEffect.set_waveAmplitude","Shaders.hx",142,0x469785f0)

void DistortBGEffect_obj::__construct(){
            	HX_GC_STACKFRAME(&_hx_pos_e1ea4856156ad031_108_new)
HXLINE( 114)		this->waveAmplitude = ((Float)0);
HXLINE( 113)		this->waveFrequency = ((Float)0);
HXLINE( 112)		this->waveSpeed = ((Float)0);
HXLINE( 110)		this->shader =  ::DistortBGShader_obj::__alloc( HX_CTX );
HXLINE( 118)		this->shader->uTime->value = ::Array_obj< Float >::fromData( _hx_array_data_7fce4f61_1,1);
            	}

Dynamic DistortBGEffect_obj::__CreateEmpty() { return new DistortBGEffect_obj; }

void *DistortBGEffect_obj::_hx_vtable = 0;

Dynamic DistortBGEffect_obj::__Create(::hx::DynamicArray inArgs)
{
	::hx::ObjectPtr< DistortBGEffect_obj > _hx_result = new DistortBGEffect_obj();
	_hx_result->__construct();
	return _hx_result;
}

bool DistortBGEffect_obj::_hx_isInstanceOf(int inClassId) {
	if (inClassId<=(int)0x4bf534a1) {
		return inClassId==(int)0x00000001 || inClassId==(int)0x4bf534a1;
	} else {
		return inClassId==(int)0x5ccf95d5;
	}
}

void DistortBGEffect_obj::update(Float elapsed){
            	HX_STACKFRAME(&_hx_pos_e1ea4856156ad031_122_update)
HXLINE( 123)		::Array< Float > base = this->shader->uTime->value;
HXDLIN( 123)		int _hx_tmp = 0;
HXDLIN( 123)		base[_hx_tmp] = (base->__get(_hx_tmp) + elapsed);
            	}


HX_DEFINE_DYNAMIC_FUNC1(DistortBGEffect_obj,update,(void))

Float DistortBGEffect_obj::set_waveSpeed(Float v){
            	HX_STACKFRAME(&_hx_pos_e1ea4856156ad031_128_set_waveSpeed)
HXLINE( 129)		this->waveSpeed = v;
HXLINE( 130)		this->shader->uSpeed->value = ::Array_obj< Float >::__new(1)->init(0,this->waveSpeed);
HXLINE( 131)		return v;
            	}


HX_DEFINE_DYNAMIC_FUNC1(DistortBGEffect_obj,set_waveSpeed,return )

Float DistortBGEffect_obj::set_waveFrequency(Float v){
            	HX_STACKFRAME(&_hx_pos_e1ea4856156ad031_135_set_waveFrequency)
HXLINE( 136)		this->waveFrequency = v;
HXLINE( 137)		this->shader->uFrequency->value = ::Array_obj< Float >::__new(1)->init(0,this->waveFrequency);
HXLINE( 138)		return v;
            	}


HX_DEFINE_DYNAMIC_FUNC1(DistortBGEffect_obj,set_waveFrequency,return )

Float DistortBGEffect_obj::set_waveAmplitude(Float v){
            	HX_STACKFRAME(&_hx_pos_e1ea4856156ad031_142_set_waveAmplitude)
HXLINE( 143)		this->waveAmplitude = v;
HXLINE( 144)		this->shader->uWaveAmplitude->value = ::Array_obj< Float >::__new(1)->init(0,this->waveAmplitude);
HXLINE( 145)		return v;
            	}


HX_DEFINE_DYNAMIC_FUNC1(DistortBGEffect_obj,set_waveAmplitude,return )


::hx::ObjectPtr< DistortBGEffect_obj > DistortBGEffect_obj::__new() {
	::hx::ObjectPtr< DistortBGEffect_obj > __this = new DistortBGEffect_obj();
	__this->__construct();
	return __this;
}

::hx::ObjectPtr< DistortBGEffect_obj > DistortBGEffect_obj::__alloc(::hx::Ctx *_hx_ctx) {
	DistortBGEffect_obj *__this = (DistortBGEffect_obj*)(::hx::Ctx::alloc(_hx_ctx, sizeof(DistortBGEffect_obj), true, "DistortBGEffect"));
	*(void **)__this = DistortBGEffect_obj::_hx_vtable;
	__this->__construct();
	return __this;
}

DistortBGEffect_obj::DistortBGEffect_obj()
{
}

void DistortBGEffect_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(DistortBGEffect);
	HX_MARK_MEMBER_NAME(shader,"shader");
	HX_MARK_MEMBER_NAME(waveSpeed,"waveSpeed");
	HX_MARK_MEMBER_NAME(waveFrequency,"waveFrequency");
	HX_MARK_MEMBER_NAME(waveAmplitude,"waveAmplitude");
	HX_MARK_END_CLASS();
}

void DistortBGEffect_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(shader,"shader");
	HX_VISIT_MEMBER_NAME(waveSpeed,"waveSpeed");
	HX_VISIT_MEMBER_NAME(waveFrequency,"waveFrequency");
	HX_VISIT_MEMBER_NAME(waveAmplitude,"waveAmplitude");
}

::hx::Val DistortBGEffect_obj::__Field(const ::String &inName,::hx::PropertyAccess inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"shader") ) { return ::hx::Val( shader ); }
		if (HX_FIELD_EQ(inName,"update") ) { return ::hx::Val( update_dyn() ); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"waveSpeed") ) { return ::hx::Val( waveSpeed ); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"waveFrequency") ) { return ::hx::Val( waveFrequency ); }
		if (HX_FIELD_EQ(inName,"waveAmplitude") ) { return ::hx::Val( waveAmplitude ); }
		if (HX_FIELD_EQ(inName,"set_waveSpeed") ) { return ::hx::Val( set_waveSpeed_dyn() ); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"set_waveFrequency") ) { return ::hx::Val( set_waveFrequency_dyn() ); }
		if (HX_FIELD_EQ(inName,"set_waveAmplitude") ) { return ::hx::Val( set_waveAmplitude_dyn() ); }
	}
	return super::__Field(inName,inCallProp);
}

::hx::Val DistortBGEffect_obj::__SetField(const ::String &inName,const ::hx::Val &inValue,::hx::PropertyAccess inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"shader") ) { shader=inValue.Cast<  ::DistortBGShader >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"waveSpeed") ) { if (inCallProp == ::hx::paccAlways) return ::hx::Val( set_waveSpeed(inValue.Cast< Float >()) );waveSpeed=inValue.Cast< Float >(); return inValue; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"waveFrequency") ) { if (inCallProp == ::hx::paccAlways) return ::hx::Val( set_waveFrequency(inValue.Cast< Float >()) );waveFrequency=inValue.Cast< Float >(); return inValue; }
		if (HX_FIELD_EQ(inName,"waveAmplitude") ) { if (inCallProp == ::hx::paccAlways) return ::hx::Val( set_waveAmplitude(inValue.Cast< Float >()) );waveAmplitude=inValue.Cast< Float >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void DistortBGEffect_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_("shader",25,bf,20,1d));
	outFields->push(HX_("waveSpeed",0e,43,dc,5b));
	outFields->push(HX_("waveFrequency",a3,fd,a6,f7));
	outFields->push(HX_("waveAmplitude",4a,90,b7,a5));
	super::__GetFields(outFields);
};

#ifdef HXCPP_SCRIPTABLE
static ::hx::StorageInfo DistortBGEffect_obj_sMemberStorageInfo[] = {
	{::hx::fsObject /*  ::DistortBGShader */ ,(int)offsetof(DistortBGEffect_obj,shader),HX_("shader",25,bf,20,1d)},
	{::hx::fsFloat,(int)offsetof(DistortBGEffect_obj,waveSpeed),HX_("waveSpeed",0e,43,dc,5b)},
	{::hx::fsFloat,(int)offsetof(DistortBGEffect_obj,waveFrequency),HX_("waveFrequency",a3,fd,a6,f7)},
	{::hx::fsFloat,(int)offsetof(DistortBGEffect_obj,waveAmplitude),HX_("waveAmplitude",4a,90,b7,a5)},
	{ ::hx::fsUnknown, 0, null()}
};
static ::hx::StaticInfo *DistortBGEffect_obj_sStaticStorageInfo = 0;
#endif

static ::String DistortBGEffect_obj_sMemberFields[] = {
	HX_("shader",25,bf,20,1d),
	HX_("waveSpeed",0e,43,dc,5b),
	HX_("waveFrequency",a3,fd,a6,f7),
	HX_("waveAmplitude",4a,90,b7,a5),
	HX_("update",09,86,05,87),
	HX_("set_waveSpeed",f1,f8,45,62),
	HX_("set_waveFrequency",06,e1,84,21),
	HX_("set_waveAmplitude",ad,73,95,cf),
	::String(null()) };

::hx::Class DistortBGEffect_obj::__mClass;

void DistortBGEffect_obj::__register()
{
	DistortBGEffect_obj _hx_dummy;
	DistortBGEffect_obj::_hx_vtable = *(void **)&_hx_dummy;
	::hx::Static(__mClass) = new ::hx::Class_obj();
	__mClass->mName = HX_("DistortBGEffect",61,4f,ce,7f);
	__mClass->mSuper = &super::__SGetClass();
	__mClass->mConstructEmpty = &__CreateEmpty;
	__mClass->mConstructArgs = &__Create;
	__mClass->mGetStaticField = &::hx::Class_obj::GetNoStaticField;
	__mClass->mSetStaticField = &::hx::Class_obj::SetNoStaticField;
	__mClass->mStatics = ::hx::Class_obj::dupFunctions(0 /* sStaticFields */);
	__mClass->mMembers = ::hx::Class_obj::dupFunctions(DistortBGEffect_obj_sMemberFields);
	__mClass->mCanCast = ::hx::TCanCast< DistortBGEffect_obj >;
#ifdef HXCPP_SCRIPTABLE
	__mClass->mMemberStorageInfo = DistortBGEffect_obj_sMemberStorageInfo;
#endif
#ifdef HXCPP_SCRIPTABLE
	__mClass->mStaticStorageInfo = DistortBGEffect_obj_sStaticStorageInfo;
#endif
	::hx::_hx_RegisterClass(__mClass->mName, __mClass);
}

