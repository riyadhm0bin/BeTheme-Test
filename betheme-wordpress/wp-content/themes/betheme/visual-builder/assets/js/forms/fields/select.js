function mfn_field_select(field, rwd) {
	let classes = ['mfn-form-control','mfn-form-select'];
	let wrapper_classes = ['form-content'];
	let data_attr = '';
	let value = field.obj_val;
	let html = '';
	let name_attr = '';

	if( _.has(field, 'key') ) {
		data_attr = `data-key="${field.key}"`;
	}

	if( _.has(field, 'preview') ){
		classes.push(field.preview);
	}

	if( _.has(field, 'input_class') ){
		classes.push(field.input_class);
	}

	if( _.has(field, 'field_class') ){
		classes.push(field.field_class);
	}

	if( _.has(field, 'id') ){
		html += `<div class="${wrapper_classes.join(' ')}">`;
		name_attr = `name="${field.id}"`;
	}

	if( _.has(field, 'on_change') ){
		classes.push('field-to-object'); // object updater only
	}else{
		classes.push('mfn-field-value'); // all on change actions
	}

	// key / label options - prevents automatic sorting

	html += `
		<select ${data_attr} ${name_attr} class="${classes.join(' ')}" autocomplete="off">

		${ _.has(field, 'js_hierarchical_options') ? '<option value="">All</option>' : '' }

		${ _.has(field, 'options') ? _.map( field.options, function(opt, i) {
			let html = '';
			
			if( i.length && i.includes('#optgroup') ) {
				if( opt != '' ){
					html += `<optgroup label="${opt}">`;
				}else{
					html += `</optgroup>`;
				}
			}else{
				html += '<option '+( value == i ? 'selected' : '' )+' value="'+i+'">'+opt+'</option>';
			}

			return html;
		}).join('') : '' }

		${ _.has(field, 'js_options') ? _.map( mfn[field.js_options], (opt, o) => '<option '+( value == o ? 'selected' : '' )+' value="'+o+'">'+opt+'</option>' ).join('') : '' }
		${ _.has(field, 'js_hierarchical_options') ? _.map( mfn[field.js_hierarchical_options], (opt) => '<option '+( value == opt.slug ? 'selected' : '' )+' value="'+opt.slug+'">'+opt.name+'</option>' ).join('') : '' }

		${ _.has(field, 'kl_options') ? _.map( field.kl_options, (opt) => '<option '+( value == opt.key ? 'selected' : '' )+' value="'+opt.key+'">'+opt.label+'</option>' ).join('') : '' }


		${ _.has(field, 'opt_append') ? _.map( field.opt_append, (opta, o) => '<option '+( value == o ? 'selected' : '' )+' value="'+o+'">'+opta+'</option>' ).join('') : '' }
	
	`;

	if( _.has(field, 'mfn_options') ) {
		html += `<option value="">- Select -</option>`;
		html += `${_.map( mfn[field.mfn_options], (opt, o) => '<option '+( value == opt['name'] ? 'selected' : '' )+' value="'+opt['name']+'">'+opt['label']+'</option>' ).join('')}`;
		
	}

	if( _.has(field, 'mfn_taxonomies') ) {
		html += `<option value="">- Select -</option>`;
		html += `<option ${ value == '0-current' ? 'selected' : '' } value="0-current">Current</option>`;
		if( _.has(mfn['taxonomies'], field.mfn_taxonomies) && _.has(mfn['taxonomies'][field.mfn_taxonomies], 'items') ) html += `${_.map( mfn['taxonomies'][field.mfn_taxonomies]['items'], (opt, o) => '<option '+( value == opt['slug'] ? 'selected' : '' )+' value="'+opt['slug']+'">'+opt['name']+'</option>' ).join('')}`;
		
	}

		html += `</select>`;

	if( _.has(field, 'id') ){
		html += `</div>`;
	}

	return html;
}