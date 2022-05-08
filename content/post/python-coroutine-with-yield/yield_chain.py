def async_call(it, ret_list=None):
    try:
        value = ret_list[0] if ret_list and len(ret_list) == 1 else ret_list
        arg_list = it.send(value)
    except StopIteration:
        print("generator %s ends" % it)
        return

    if type(arg_list) in (list, tuple):
        imp_func, args = arg_list[0], list(arg_list[1:])
    else:
        imp_func, args = arg_list, []

    callback = lambda *cb_args: async_call(it, cb_args)
    imp_func(*args, callback=callback)

def make_async(func):
    def _wrapper(*args, **kwargs):
        async_call(func(*args, **kwargs))
    return _wrapper

def fd(_idx, callback):
    print("fd(%s, %s)" % (_idx, callback))
    return 'EOF'
    callback('fd:%s' % _idx)
    print("fd exit")

@make_async
def fb(_idx, callback):
    print("fb(%s, %s)" % (_idx, callback))
    ret = yield fd, _idx
    callback('fb:%s' % ret)
    print("fb exit")

def fc(_idx, callback):
    print("fc(%s, %s)" % (_idx, callback))
    callback('fc:%s' % _idx)
    print("fc exit")

@make_async
def fa(*args, **kwargs):
    print("fa(%s, %s)" % (args, kwargs))
    for idx in range(2):
        if idx % 2 == 0:
            f = fb
        else:
            f = fc
        ret = yield f, idx
        print("%sth iteration: ret in fa is %s" % (idx, ret))
    print("fa exit")

if __name__ == '__main__':
    fa()
