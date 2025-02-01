class_name Funk

const UNDEFINED = &'___funk__undefined__value___'

static func is_undefined(thing):
  return (typeof(thing) == TYPE_STRING_NAME && thing == Funk.UNDEFINED)

static func option(options, name:String, default=null, expected_type=null):
  var value = options[name] if name in options else default
  if expected_type != null:
    if not is_instance_of(value, expected_type):
      var t = typeof(value)
      t = t if t != TYPE_OBJECT else t.get_script().get_global_name()
      push_error('type "{opt_type}" of option "{opt_name}" does not match (or is not a subclass of) expected type "{exp_type}"'.format({
        opt_name = name,
        opt_type = t,
        exp_type = expected_type
      }))
      return default
  return value

static func match_args(params, args):
  var matched = []
  var unmatched = []
  var cloned_params = params.duplicate()
  var cloned_args = args.duplicate()

  while cloned_params.size():
    var param = cloned_params.pop_front()
    var arg = cloned_args.front()
    if is_undefined(arg):
      break

    if param.type != typeof(arg) and param.type != TYPE_NIL:
      break

    matched.push_back(cloned_args.pop_front())

  while cloned_args.size():
    var arg = cloned_args.pop_front()
    if not is_undefined(arg):
      unmatched.push_back(arg)

  return {matched=matched, unmatched=unmatched}

static func merge_array(arg0 = UNDEFINED, arg1 = UNDEFINED, arg2 = UNDEFINED, arg3 = UNDEFINED, arg4 = UNDEFINED, rest = []) -> Array:
  var to_merge = [arg0, arg1, arg2, arg3, arg4]
  to_merge.append_array(rest)

  var merged = []
  for item in to_merge:
    if is_instance_of(item, TYPE_ARRAY):
      merged.append_array(item)
    elif not is_undefined(item):
      merged.append(item)

  return merged

static func invoke(fn: Callable, args: Array = []):
  if fn.get_argument_count() > 0:
    return fn.callv(args)
  else:
    return fn.call()

static func passthrough(fn):
  return (
    func(arg0=UNDEFINED, arg1=UNDEFINED, arg2=UNDEFINED, arg3=UNDEFINED, arg4=UNDEFINED, rest=[]):
      invoke(fn, merge_array(arg0, arg1, arg2, arg3, arg4, rest))
  )
