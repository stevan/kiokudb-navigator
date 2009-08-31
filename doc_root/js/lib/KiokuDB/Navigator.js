
if (KiokuDB == undefined) var KiokuDB = function () {};

KiokuDB.Navigator = function (url) {
    this._JSORB_CLIENT = new JSORB.Client ({
        base_url       : url,
        base_namespace : '/kiokudb/navigator/'
    });
}

KiokuDB.Navigator.prototype._abort_current_call = function () {
    this._JSORB_CLIENT.abort_current_call();
}

KiokuDB.Navigator.prototype._call = function (method, callback) {
    this._JSORB_CLIENT.call(method, callback)
}

KiokuDB.Navigator.prototype.lookup = function (id, callback) {
    this._call(
        { method : 'lookup', params : [ id ] },
        callback
    )
}

KiokuDB.Navigator.prototype.load_root_set = function (callback) {
    this._call(
        { method : 'root_set' },
        callback
    );
}