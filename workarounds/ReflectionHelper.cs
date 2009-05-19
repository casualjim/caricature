using System;
using System.Reflection;

namespace Workarounds
{          
    public static class ReflectionHelper
    {

        public static PropertyInfo[] GetInstanceProperties(Type target)
        {
            return target.GetProperties(BindingFlags.Public | BindingFlags.Instance);
        }

        public static PropertyInfo[] GetStaticProperties(Type target)
        {
            return target.GetProperties(BindingFlags.Public | BindingFlags.Static);
        }

        public static MethodInfo[] GetInstanceMethods(Type target)
        {
            return target.GetMethods(BindingFlags.Public | BindingFlags.Instance);
        }

        public static MethodInfo[] GetStaticMethods(Type target)
        {
            return target.GetMethods(BindingFlags.Public | BindingFlags.Static);
        }

    }
}