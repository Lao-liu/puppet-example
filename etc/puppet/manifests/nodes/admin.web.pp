node /^admin\d*\.web/ inherits default {
	include role_web_server
	include role_php_fcgi_server
	include role_vpn_enduser

	#####################this is for ecshop admin, like static
	# admin������puppet����Ӧ�÷����ű��μ�admin�����ϵ�sh�ļ�
	#####################this is for ecshop admin, like static end #################
	
	# this is for lotusphp_app: acp, like detial, www, help etc
	$app_name = "acp"
	include role_lotusphp_app_server
}
