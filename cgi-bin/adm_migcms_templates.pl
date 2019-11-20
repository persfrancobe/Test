#!/usr/bin/perl -I../lib

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Librairies utilisées
use CGI::Carp 'fatalsToBrowser';
use CGI;   # standard package for easy CGI scripting
use DBI;   # standard package for Database access
use def; # home-made package for defines
use tools; # home-made package for tools
use dm;
use def_handmade;

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

###############################################################################################
####################################	CODE DU PROGRAMME		######################################
###############################################################################################
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


$dm_cfg{customtitle} = $migctrad{templates_title};

my $htaccess_ssl = $config{rewrite_ssl};
my $htaccess_protocol_rewrite = "http";
if($htaccess_ssl eq 'y') {
  $htaccess_protocol_rewrite = "https";
}
$dm_cfg{disable_edit_link} = 'y';
$dm_cfg{enable_search} = 1;
$dm_cfg{vis_opt} = 0;
$dm_cfg{sort_opt} = 0;
$dm_cfg{wherep} = "";
$dm_cfg{table_name} = "templates";
$dm_cfg{list_table_name} = "$dm_cfg{table_name}";
$dm_cfg{self} = "$config{baseurl}/cgi-bin/adm_migcms_templates.pl?";
$dm_cfg{duplicate} = 1;
$dm_cfg{default_ordby} = 'id DESC';

%migc_templates_types = (
                 '01/page'=>'Page',
                 '02/parag'=>'Paragraphe',
                 '03/menu'=>'Menu',  
                 '04/block'=>'Bloc',  
                 '05/prod'=>'Produit',  
                 '06/shop'=>'Boutique',  
				 '07/dataform'=>'Formulaire', 
                 '08/mailing'=>'Mailing',  
                 '09/mailing_parag'=>'Paragraphe mailing',  
                 '10/data'=>'Annuaire',
                 '11/search'=>'Recherche',
                );

foreach my $k (keys(%migc_templates_handmade_types)) {
   $migc_templates_types{$k} = $migc_templates_handmade_types{$k};
}
				
        
        


#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Description des champs qui vont être récupérer de la bdd
%dm_dfl = (
	    '01/id'=> {
	        'title'=>'ID',
	        'fieldtype'=>'text',
	        'hidden'=>1,
	        'search' => 'y',
	    },
		
		'02/name'=> {
	        'title'=>'Nom du template',
	        'fieldtype'=>'text',
	        'fieldsize'=>'50',
	        'search' => 'y',
	        'mandatory'=>{"type" => 'not_empty'},
	    },
	    
	    '03/template'=> {
	        'title'=>'Code HTML du template',
	        'fieldtype'=>'textarea',
			'data_type'=>'code',
	        'fieldparams'=>'',
	    },
	    
	    '04/type'=> {
	        'title'=>'Type de template',
	        'fieldtype'=>'listbox',
			'search' => 'y',
	        'fieldvalues'=>\%migc_templates_types,
	    },
	    
	    # '05/id_css'=> {
	        # 'title'=>$migctrad{templates_id_css},
	        # 'fieldtype'=>'listboxtable',
	        # 'lbtable'=>'css',
	        # 'lbkey'=>'css.id',
	        # 'lbdisplay'=>'css.name', 
	        # 'mandatory'=>{"type" => 'not_zero'},
	    # },

	    # '06/id_role'=> {
	        # 'title'=>$migctrad{templates_id_role},
	        # 'fieldtype'=>'listboxtable',
	        # 'lbtable'=>'roles',
	        # 'lbkey'=>'roles.id',
	        # 'lbdisplay'=>'roles.function', 
	        # 'mandatory'=>{"type" => 'not_zero'},
	    # },
		,
		'84/size_mini'=> 
		{
			'title'=>"Taille image MINI",
			'fieldtype'=>'text',
		}
		,
		'85/size_small'=> 
		{
			'title'=>"Taille image SMALL",
			'fieldtype'=>'text',
		}
		,
		'86/size_medium'=> 
		{
			'title'=>"Taille image MEDIUM",
			'fieldtype'=>'text',
		}
		,
		'87/size_large'=> 
		{
			'title'=>"Taille image LARGE",
			'fieldtype'=>'text',
		}
		,
		'88/size_og'=> 
		{
			'title'=>"Taille image OG",
			'fieldtype'=>'text',
		}
		,
		'89/active_title'=> 
		{
			'title'=>"Titre",
			'default_value'=>'y',
			'fieldtype'=>'checkbox'
		}
		,
		'90/active_content'=> 
		{
			'title'=>"Contenu",
			'default_value'=>'y',
			'fieldtype'=>'checkbox'
		}
		,
		'91/active_txt_1'=> 
		{
			'title'=>"Texte 1",
			'default_value'=>'n',
			'fieldtype'=>'checkbox'
		}
		,
		'92/active_txt_2'=> 
		{
			'title'=>"Texte 2",
			'default_value'=>'n',
			'fieldtype'=>'checkbox'
		}
		,
		'93/active_txt_3'=> 
		{
			'title'=>"Texte 3",
			'default_value'=>'n',
			'fieldtype'=>'checkbox'
		}
		,
		'94/active_txt_4'=> 
		{
			'title'=>"Texte 4",
			'default_value'=>'n',
			'fieldtype'=>'checkbox'
		},
	    '95/active_txt_5'=>
		{
			'title'=>"Texte 5",
			'default_value'=>'n',
			'fieldtype'=>'checkbox'
		}
		,
		'96/active_textwysiwyg_1'=>
		{
			'title'=>"Contenu WYSIWYG 1",
			'default_value'=>'n',
			'fieldtype'=>'checkbox'
		}
		,
		'97/active_textwysiwyg_2'=>
		{
			'title'=>"Contenu WYSIWYG 2",
			'default_value'=>'n',
			'fieldtype'=>'checkbox'
		}
		,
		'98/active_textwysiwyg_3'=>
		{
			'title'=>"Contenu WYSIWYG 3",
			'default_value'=>'n',
			'fieldtype'=>'checkbox'
		}
		,
		'99/active_textwysiwyg_4'=>
		{
			'title'=>"Contenu WYSIWYG 4",
			'default_value'=>'n',
			'fieldtype'=>'checkbox'
		},
	    '100/active_textwysiwyg_5'=>
		{
			'title'=>"Contenu WYSIWYG 5",
			'default_value'=>'n',
			'fieldtype'=>'checkbox'
		}
		,
		'101/active_pics'=>
		{
			'title'=>"Images / photos",
			'default_value'=>'y',
			'fieldtype'=>'checkbox'
		}
	    
	);

%dm_display_fields = (
			"1/ID"=>"id",
			"2/$migctrad{templates_name}"=>"name",
			"3/$migctrad{templates_type}"=>"type",

		);

%dm_lnk_fields = (
		);

%dm_mapping_list = (
);

%dm_filters = (
		);

# this script's name

$sw = $cgi->param('sw') || "list";

see();

my @fcts = qw(
			add_form
			mod_form
			list
			add_db
			mod_db
			del_db
		);

if (is_in(@fcts,$sw)) { 
    dm_init();
    &$sw();

	my $suppl_js=<<"EOH";
    
     <style>
      </style>
    
   	
EOH
	
    print wfw_app_layout($suppl_js.$dm_output{content},$dm_output{title},"",$gen_bar,$spec_bar);
}

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------