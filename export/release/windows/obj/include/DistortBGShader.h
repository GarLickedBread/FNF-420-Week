#ifndef INCLUDED_DistortBGShader
#define INCLUDED_DistortBGShader

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#ifndef INCLUDED_flixel_graphics_tile_FlxGraphicsShader
#include <flixel/graphics/tile/FlxGraphicsShader.h>
#endif
HX_DECLARE_CLASS0(DistortBGShader)
HX_DECLARE_CLASS3(flixel,graphics,tile,FlxGraphicsShader)
HX_DECLARE_CLASS2(openfl,display,GraphicsShader)
HX_DECLARE_CLASS2(openfl,display,Shader)
HX_DECLARE_CLASS2(openfl,display,ShaderParameter_Float)



class HXCPP_CLASS_ATTRIBUTES DistortBGShader_obj : public  ::flixel::graphics::tile::FlxGraphicsShader_obj
{
	public:
		typedef  ::flixel::graphics::tile::FlxGraphicsShader_obj super;
		typedef DistortBGShader_obj OBJ_;
		DistortBGShader_obj();

	public:
		enum { _hx_ClassId = 0x08729935 };

		void __construct();
		inline void *operator new(size_t inSize, bool inContainer=true,const char *inName="DistortBGShader")
			{ return ::hx::Object::operator new(inSize,inContainer,inName); }
		inline void *operator new(size_t inSize, int extra)
			{ return ::hx::Object::operator new(inSize+extra,true,"DistortBGShader"); }
		static ::hx::ObjectPtr< DistortBGShader_obj > __new();
		static ::hx::ObjectPtr< DistortBGShader_obj > __alloc(::hx::Ctx *_hx_ctx);
		static void * _hx_vtable;
		static Dynamic __CreateEmpty();
		static Dynamic __Create(::hx::DynamicArray inArgs);
		//~DistortBGShader_obj();

		HX_DO_RTTI_ALL;
		::hx::Val __Field(const ::String &inString, ::hx::PropertyAccess inCallProp);
		::hx::Val __SetField(const ::String &inString,const ::hx::Val &inValue, ::hx::PropertyAccess inCallProp);
		void __GetFields(Array< ::String> &outFields);
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		bool _hx_isInstanceOf(int inClassId);
		::String __ToString() const { return HX_("DistortBGShader",f5,b3,4b,3c); }

		 ::openfl::display::ShaderParameter_Float tx;
		 ::openfl::display::ShaderParameter_Float uTime;
		 ::openfl::display::ShaderParameter_Float uSpeed;
		 ::openfl::display::ShaderParameter_Float uFrequency;
		 ::openfl::display::ShaderParameter_Float uWaveAmplitude;
};


#endif /* INCLUDED_DistortBGShader */ 
