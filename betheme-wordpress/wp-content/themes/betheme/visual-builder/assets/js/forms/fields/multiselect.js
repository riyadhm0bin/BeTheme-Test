function mfn_field_multiselect(field) {
	let value = field.obj_val;
	let options = [];

	if( _.has(field, 'post_tax') ) {
		let find_pt = mfn['post_types'].filter( (p) => p.name == mfn.current_post_type )[0];
		if( find_pt && _.has(find_pt, 'mfn_tax') ) {
			_.map(find_pt['mfn_tax'], function(el) {
				if( _.has(mfn['taxonomies'], el['name']) && _.has(mfn['taxonomies'][el['name']], 'items') /*&& mfn['taxonomies'][el['name']]['items'].length*/ ) {
					_.map(mfn['taxonomies'][el['name']]['items'], function(i) {
						options.push(i);
					});
				}
			});
		}
		if( mfn.post_type == 'template' && mfn.builder_type != 'standard' && !options.filter( (o) => o.id == '0-current' ).length ) options.push({ id: '0-current', name: 'Current' });
	}else if( _.has(field, 'tax_cpt') && _.has(mfn['taxonomies'], mfn.current_tax) /*&& mfn['taxonomies'][mfn.current_tax]['items'].length*/ ) {
		options = mfn['taxonomies'][mfn.current_tax]['items'];
		//if( !options.filter( (o) => o.id == '0-current' ).length ) options.push({ id: '0-current', name: 'Current' });
	}else if( _.has(field, 'js_hierarchical_options') ) {
		options = mfn[field.js_hierarchical_options];
	}

	if( _.has(edited_item['attr'], field.id) && edited_item['attr'][field.id].length ) {
		value = edited_item['attr'][field.id];
	}

	let html = `<div class="form-content"><div data-val="${ value }" class="form-group mfn-multiselect-field-wrapper">
		<div class="form-control">
			${ _.map( value, (val) => `<span data-id="${val.key}">&#10005; ${val.value}</span>` ).join('') }
			<input data-type="${ _.has(field, 'post_tax') ? 'post_tax' : 'tax_cpt' }" type="text" class="mfn-multiselect-input" placeholder="Type...">
		</div>
		<ul class="mfn-multiselect-options"> 
			${ _.has(field, 'opt_append') ? _.map( field.opt_append, (opta, o) => `<li data-name="${o}" data-id="${o}" ${value == o ? 'class="selected"' : ''}>${opta}</li>` ).join('') : '' }
			${ _.map( options, (opt) => `
				<li data-name="${opt.name.replaceAll("&nbsp;", "")}" data-id="${opt.term_id}" ${ _.has(edited_item['attr'], field.id) && typeof edited_item['attr'][field.id] === 'object' && edited_item['attr'][field.id].filter( (item) => item.key == opt.term_id ).length ? "class=\"selected\"" : "" }>
					${opt.name}
					</li>`).join('') 
			}
		</ul>
	</div></div>`;
	return html;
}