#ifndef INCLUDED_InvertColorsEffect
#define INCLUDED_InvertColorsEffect

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#ifndef INCLUDED_Effect
#include <Effect.h>
#endif
HX_DECLARE_CLASS0(Effect)
HX_DECLARE_CLASS0(InvertColorsEffect)
HX_DECLARE_CLASS0(InvertShader)
HX_DECLARE_CLASS3(flixel,graphics,tile,FlxGraphicsShader)
HX_DECLARE_CLASS2(openfl,display,GraphicsShader)
HX_DECLARE_CLASS2(openfl,display,Shader)



class HXCPP_CLASS_ATTRIBUTES InvertColorsEffect_obj : public  ::Effect_obj
{
	public:
		typedef  ::Effect_obj super;
		typedef InvertColorsEffect_obj OBJ_;
		InvertColorsEffect_obj();

	public:
		enum { _hx_ClassId = 0x265c7b77 };

		void __construct();
		inline void *operator new(size_t inSize, bool inContainer=true,const char *inName="InvertColorsEffect")
			{ return ::hx::Object::operator new(inSize,inContainer,inName); }
		inline void *operator new(size_t inSize, int extra)
			{ return ::hx::Object::operator new(inSize+extra,true,"InvertColorsEffect"); }
		static ::hx::ObjectPtr< InvertColorsEffect_obj > __new();
		static ::hx::ObjectPtr< InvertColorsEffect_obj > __alloc(::hx::Ctx *_hx_ctx);
		static void * _hx_vtable;
		static Dynamic __CreateEmpty();
		static Dynamic __Create(::hx::DynamicArray inArgs);
		//~InvertColorsEffect_obj();

		HX_DO_RTTI_ALL;
		::hx::Val __Field(const ::String &inString, ::hx::PropertyAccess inCallProp);
		::hx::Val __SetField(const ::String &inString,const ::hx::Val &inValue, ::hx::PropertyAccess inCallProp);
		void __GetFields(Array< ::String> &outFields);
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		bool _hx_isInstanceOf(int inClassId);
		::String __ToString() const { return HX_("InvertColorsEffect",b7,98,98,ce); }

		 ::InvertShader shader;
};


#endif /* INCLUDED_InvertColorsEffect */ 
