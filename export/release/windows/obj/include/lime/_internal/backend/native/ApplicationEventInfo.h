#ifndef INCLUDED_lime__internal_backend_native_ApplicationEventInfo
#define INCLUDED_lime__internal_backend_native_ApplicationEventInfo

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_STACK_FRAME(_hx_pos_1a94701d58bd3d3e_625_new)
HX_DECLARE_CLASS4(lime,_internal,backend,native,ApplicationEventInfo)

namespace lime{
namespace _internal{
namespace backend{
namespace native{


class HXCPP_CLASS_ATTRIBUTES ApplicationEventInfo_obj : public ::hx::Object
{
	public:
		typedef ::hx::Object super;
		typedef ApplicationEventInfo_obj OBJ_;
		ApplicationEventInfo_obj();

	public:
		enum { _hx_ClassId = 0x3afc4820 };

		void __construct( ::Dynamic type,::hx::Null< int >  __o_deltaTime);
		inline void *operator new(size_t inSize, bool inContainer=false,const char *inName="lime._internal.backend.native.ApplicationEventInfo")
			{ return ::hx::Object::operator new(inSize,inContainer,inName); }
		inline void *operator new(size_t inSize, int extra)
			{ return ::hx::Object::operator new(inSize+extra,false,"lime._internal.backend.native.ApplicationEventInfo"); }

		inline static ::hx::ObjectPtr< ApplicationEventInfo_obj > __new( ::Dynamic type,::hx::Null< int >  __o_deltaTime) {
			::hx::ObjectPtr< ApplicationEventInfo_obj > __this = new ApplicationEventInfo_obj();
			__this->__construct(type,__o_deltaTime);
			return __this;
		}

		inline static ::hx::ObjectPtr< ApplicationEventInfo_obj > __alloc(::hx::Ctx *_hx_ctx, ::Dynamic type,::hx::Null< int >  __o_deltaTime) {
			ApplicationEventInfo_obj *__this = (ApplicationEventInfo_obj*)(::hx::Ctx::alloc(_hx_ctx, sizeof(ApplicationEventInfo_obj), false, "lime._internal.backend.native.ApplicationEventInfo"));
			*(void **)__this = ApplicationEventInfo_obj::_hx_vtable;
{
            		int deltaTime = __o_deltaTime.Default(0);
            	HX_STACKFRAME(&_hx_pos_1a94701d58bd3d3e_625_new)
HXLINE( 626)		( ( ::lime::_internal::backend::native::ApplicationEventInfo)(__this) )->type = ( (int)(type) );
HXLINE( 627)		( ( ::lime::_internal::backend::native::ApplicationEventInfo)(__this) )->deltaTime = deltaTime;
            	}
		
			return __this;
		}

		static void * _hx_vtable;
		static Dynamic __CreateEmpty();
		static Dynamic __Create(::hx::DynamicArray inArgs);
		//~ApplicationEventInfo_obj();

		HX_DO_RTTI_ALL;
		::hx::Val __Field(const ::String &inString, ::hx::PropertyAccess inCallProp);
		::hx::Val __SetField(const ::String &inString,const ::hx::Val &inValue, ::hx::PropertyAccess inCallProp);
		void __GetFields(Array< ::String> &outFields);
		static void __register();
		bool _hx_isInstanceOf(int inClassId);
		::String __ToString() const { return HX_("ApplicationEventInfo",58,f8,5f,3d); }

		int deltaTime;
		int type;
		 ::lime::_internal::backend::native::ApplicationEventInfo clone();
		::Dynamic clone_dyn();

};

} // end namespace lime
} // end namespace _internal
} // end namespace backend
} // end namespace native

#endif /* INCLUDED_lime__internal_backend_native_ApplicationEventInfo */ 