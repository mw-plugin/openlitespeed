
function pluginOLSRead(){
	 var con = '<ul class="help-info-text c7">';
    con += '<li style="color:red;">/usr/local/lsws/admin/misc/admpass.sh(执行设置密码)</li>';
    con += '<li style="color:red;">OpenLiteSpeed 监听端口 8088 和 7080，因此我们必须允许这些端口访问。</li>';
    con += '</ul>';

    $(".soft-man-con").html(con);
}