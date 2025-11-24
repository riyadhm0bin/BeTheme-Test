function mfn_field_select_ajax(field, rwd) {
	let value = field.obj_val;
	let html = '';

	html += `<div class="form-group">
			<div class="form-control">

				<div class="mfn-select-ajax">
					<input type="hidden" name="${field.id}" value="${value}" class="mfn-field-value"><input type="text" value="${value}" placeholder="Search page..." class="mfn-form-control mfn-select-ajax-input">
				</div>

			</div>
		</div>
	`;

	return html;
}