#ifndef INCLUDED_InvertShader
#define INCLUDED_InvertShader

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#ifndef INCLUDED_flixel_graphics_tile_FlxGraphicsShader
#include <flixel/graphics/tile/FlxGraphicsShader.h>
#endif
HX_DECLARE_CLASS0(InvertShader)
HX_DECLARE_CLASS3(flixel,graphics,tile,FlxGraphicsShader)
HX_DECLARE_CLASS2(openfl,display,GraphicsShader)
HX_DECLARE_CLASS2(openfl,display,Shader)



class HXCPP_CLASS_ATTRIBUTES InvertShader_obj : public  ::flixel::graphics::tile::FlxGraphicsShader_obj
{
	public:
		typedef  ::flixel::graphics::tile::FlxGraphicsShader_obj super;
		typedef InvertShader_obj OBJ_;
		InvertShader_obj();

	public:
		enum { _hx_ClassId = 0x1c6063e7 };

		void __construct();
		inline void *operator new(size_t inSize, bool inContainer=true,const char *inName="InvertShader")
			{ return ::hx::Object::operator new(inSize,inContainer,inName); }
		inline void *operator new(size_t inSize, int extra)
			{ return ::hx::Object::operator new(inSize+extra,true,"InvertShader"); }
		static ::hx::ObjectPtr< InvertShader_obj > __new();
		static ::hx::ObjectPtr< InvertShader_obj > __alloc(::hx::Ctx *_hx_ctx);
		static void * _hx_vtable;
		static Dynamic __CreateEmpty();
		static Dynamic __Create(::hx::DynamicArray inArgs);
		//~InvertShader_obj();

		HX_DO_RTTI_ALL;
		static void __register();
		bool _hx_isInstanceOf(int inClassId);
		::String __ToString() const { return HX_("InvertShader",fb,da,9f,9c); }

};


#endif /* INCLUDED_InvertShader */ 
