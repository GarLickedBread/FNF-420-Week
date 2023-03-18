#ifndef INCLUDED_PulseEffect
#define INCLUDED_PulseEffect

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#ifndef INCLUDED_Effect
#include <Effect.h>
#endif
HX_DECLARE_CLASS0(Effect)
HX_DECLARE_CLASS0(PulseEffect)
HX_DECLARE_CLASS0(PulseShader)
HX_DECLARE_CLASS3(flixel,graphics,tile,FlxGraphicsShader)
HX_DECLARE_CLASS2(openfl,display,GraphicsShader)
HX_DECLARE_CLASS2(openfl,display,Shader)



class HXCPP_CLASS_ATTRIBUTES PulseEffect_obj : public  ::Effect_obj
{
	public:
		typedef  ::Effect_obj super;
		typedef PulseEffect_obj OBJ_;
		PulseEffect_obj();

	public:
		enum { _hx_ClassId = 0x07f907de };

		void __construct();
		inline void *operator new(size_t inSize, bool inContainer=true,const char *inName="PulseEffect")
			{ return ::hx::Object::operator new(inSize,inContainer,inName); }
		inline void *operator new(size_t inSize, int extra)
			{ return ::hx::Object::operator new(inSize+extra,true,"PulseEffect"); }
		static ::hx::ObjectPtr< PulseEffect_obj > __new();
		static ::hx::ObjectPtr< PulseEffect_obj > __alloc(::hx::Ctx *_hx_ctx);
		static void * _hx_vtable;
		static Dynamic __CreateEmpty();
		static Dynamic __Create(::hx::DynamicArray inArgs);
		//~PulseEffect_obj();

		HX_DO_RTTI_ALL;
		::hx::Val __Field(const ::String &inString, ::hx::PropertyAccess inCallProp);
		::hx::Val __SetField(const ::String &inString,const ::hx::Val &inValue, ::hx::PropertyAccess inCallProp);
		void __GetFields(Array< ::String> &outFields);
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		bool _hx_isInstanceOf(int inClassId);
		::String __ToString() const { return HX_("PulseEffect",6a,86,3b,d4); }

		 ::PulseShader shader;
		Float waveSpeed;
		Float waveFrequency;
		Float waveAmplitude;
		bool Enabled;
		void update(Float elapsed);
		::Dynamic update_dyn();

		Float set_waveSpeed(Float v);
		::Dynamic set_waveSpeed_dyn();

		bool set_Enabled(bool v);
		::Dynamic set_Enabled_dyn();

		Float set_waveFrequency(Float v);
		::Dynamic set_waveFrequency_dyn();

		Float set_waveAmplitude(Float v);
		::Dynamic set_waveAmplitude_dyn();

};


#endif /* INCLUDED_PulseEffect */ 
