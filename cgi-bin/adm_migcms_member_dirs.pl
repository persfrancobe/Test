#!/usr/bin/perl -I../lib -w

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Librairies utilisées
use CGI::Carp 'fatalsToBrowser';
use CGI;   # standard package for easy CGI scripting
use DBI;   # standard package for Database access
use def; # home-made package for defines
use tools; # home-made package for tools
use dm;
use data;

my $id=get_quoted('id');
$sw = $cgi->param('sw') || "list";
my $sel = get_quoted('sel');
$dm_cfg{after_add_ref}     = \&after_save;
$dm_cfg{after_mod_ref}     = \&after_save;
$dm_cfg{'list_custom_action_1_func'} = \&enfants;
$dm_cfg{vis_opt} = 1;
$dm_cfg{sort_opt} = 1;
$dm_cfg{breadcrumb_func}= \&breadcrumb_func;

$dm_cfg{table_name} = "migcms_member_dirs";

$dm_cfg{list_table_name} = "$dm_cfg{table_name}";
$dm_cfg{wherep_ordby} = "ordby";
$dm_cfg{self} = "$config{baseurl}/cgi-bin/adm_$dm_cfg{table_name}.pl?";
$dm_cfg{file_prefixe} = 'MD';

$cpt = 9;
	

%dm_dfl = (
	sprintf("%05d", $cpt++).'/name' => {'title'=>"Nom",'fieldtype'=>'text',"type" => 'not_empty',search=>'y'},
	);
	

%dm_display_fields = 
(
	"02/Nom"=>"name"
);



see();

my @fcts = qw(
			list
		);

if (is_in(@fcts,$sw)) 
{ 
    dm_init();
    &$sw();

    $migc_output{content} .= $dm_output{content};
    $migc_output{title} = $dm_output{title}.$migc_output{title};
		
    print migc_app_layout($js.$migc_output{content},$migc_output{title},"",$gen_bar,$spec_bar);
}


sub after_save
{
    my $dbh=$_[0];
    my $id=$_[1];
    # my %rec = read_table($dbh,$dm_cfg{table_name},$id);
}

sub enfants
{
	my $id = $_[0];
	my $colg = $_[1];
	my %record = %{$_[2]};
	my $self = "$config{baseurl}/cgi-bin/adm_migcms_tags.pl?sel=".get_quoted('sel').'&id_migcms_member_dir='.$id;
	
	my $acces = <<"EOH";
		<a class="btn btn-primary" href="$self" data-original-title="Consulter les groupes du dossier" target="" data-placement="bottom">
		<i class="fa fa-sitemap fa-fw" aria-hidden="true"></i>
		</a>
EOH

	return $acces;
}


sub breadcrumb_func
{
    # my $dbh=$_[0];
    my $id=$_[1];
		my %migcms_setup = sql_line({debug=>0,table=>"migcms_setup",select=>'',where=>"",limit=>'0,1'});
	my $url_home = $migcms_setup{admin_first_page_url};

	my $id_migcms_member_dir = get_quoted('id_migcms_member_dir');
	my %migcms_member_dirs = read_table($dbh,'migcms_member_dirs',$id_migcms_member_dir);
	# my %sel = sql_line({select=>"id", table=>"scripts", where=>"url LIKE '%adm_migcms_member_dirs.pl%'"});

	
	my $breadcrumb = <<"EOH";
	<ul class="breadcrumb panel">
	<li><a href="$config{baseurl}/cgi-bin/$url_home" data-original-title="$migctrad{backtohome}"><i class="fa fa-home"></i> $migctrad{home}</a></li>
			<li>Groupes</li>			
	</ul>
EOH
	
	return $breadcrumb;
	
}