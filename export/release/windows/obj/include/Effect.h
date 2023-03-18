#ifndef INCLUDED_Effect
#define INCLUDED_Effect

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS0(Effect)
HX_DECLARE_CLASS3(flixel,graphics,tile,FlxGraphicsShader)
HX_DECLARE_CLASS2(openfl,display,GraphicsShader)
HX_DECLARE_CLASS2(openfl,display,Shader)



class HXCPP_CLASS_ATTRIBUTES Effect_obj : public ::hx::Object
{
	public:
		typedef ::hx::Object super;
		typedef Effect_obj OBJ_;
		Effect_obj();

	public:
		enum { _hx_ClassId = 0x5ccf95d5 };

		void __construct();
		inline void *operator new(size_t inSize, bool inContainer=false,const char *inName="Effect")
			{ return ::hx::Object::operator new(inSize,inContainer,inName); }
		inline void *operator new(size_t inSize, int extra)
			{ return ::hx::Object::operator new(inSize+extra,false,"Effect"); }

		inline static ::hx::ObjectPtr< Effect_obj > __new() {
			::hx::ObjectPtr< Effect_obj > __this = new Effect_obj();
			__this->__construct();
			return __this;
		}

		inline static ::hx::ObjectPtr< Effect_obj > __alloc(::hx::Ctx *_hx_ctx) {
			Effect_obj *__this = (Effect_obj*)(::hx::Ctx::alloc(_hx_ctx, sizeof(Effect_obj), false, "Effect"));
			*(void **)__this = Effect_obj::_hx_vtable;
			return __this;
		}

		static void * _hx_vtable;
		static Dynamic __CreateEmpty();
		static Dynamic __Create(::hx::DynamicArray inArgs);
		//~Effect_obj();

		HX_DO_RTTI_ALL;
		::hx::Val __Field(const ::String &inString, ::hx::PropertyAccess inCallProp);
		static void __register();
		bool _hx_isInstanceOf(int inClassId);
		::String __ToString() const { return HX_("Effect",b1,ce,37,95); }

		void setValue( ::flixel::graphics::tile::FlxGraphicsShader shader,::String variable,Float value);
		::Dynamic setValue_dyn();

};


#endif /* INCLUDED_Effect */ 
