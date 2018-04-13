exports.spec=spec;
exports.main=main;

var MS3=_MLS.require('mountainsort3',{owner:'jmagland@flatironinstitute.org',title:'mountainsortalg.mls'});
//var SV=_MLS.require('standard_views',{owner:'jmagland@flatironinstitute.org',title:'mountainsortvis.mls'});

function spec() {

  var parameters=[
    {name:"first_only",optional:true,default_value:'false'}
  ];

  return {
    inputs:[],
    outputs:[],
    parameters:parameters
  }
}

function main(inputs,outputs,parameters) {
  var study=_MLS.study;
  
  var sort_params={
    freq_min:300,
    freq_max:6000,
    mask_out_artifacts:'false',
    whiten:'true',
    curate:'true',
    detect_threshold:3,
    adjacency_radius:-1
  };

  var datasets=study.datasets;
  for (var id in datasets) {
    process_dataset(id,study.datasets[id],sort_params);
    if (parameters.first_only=='true')
      break;
  }
}

function process_dataset(id,X,pp) {
  var A=MS3.sort_dataset(X,pp);
  
  if (X.files['raw.mda']) {
    _MLS.setResult(id+'/raw.mda',X.files['raw.mda']);
    //SV.view_timeseries(id+'/raw.view',A.raw);
  }
  if (A.filt)
    _MLS.setResult(id+'/filt.mda',A.filt);
  if (A.pre)
    _MLS.setResult(id+'/pre.mda',A.filt);

  _MLS.setResult(id+'/firings.mda',A.firings);
  //_MLS.upload(A.firings);
  var templates=MS3.compute_templates(A.filt||X.files['raw.mda'],A.firings,{});
  _MLS.setResult(id+'/templates.mda',templates);
  //_MLS.upload(templates)
  //SV.view_templates(id+'/templates.view',templates);
  
  if (A.firings_curated) {
    _MLS.setResult(id+'/firings_curated.mda',A.firings_curated);
    //_MLS.upload(A.firings_curated);
    var templates_curated=MS3.compute_templates(A.filt||X.files['raw.mda'],A.firings_curated,{});
    _MLS.setResult(id+'/templates_curated.mda',templates_curated);
  }

  if (A.cluster_metrics) {
    _MLS.setResult(id+'/cluster_metrics.json',A.cluster_metrics);
    //_MLS.upload(A.cluster_metrics);
  }
}

