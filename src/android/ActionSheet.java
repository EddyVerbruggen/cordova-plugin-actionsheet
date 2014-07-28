package nl.xservices.plugins.actionsheet;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.text.TextUtils;

/**
 * WSB-2481
 * 
 * https://github.com/bpappin/cordova-plugin-actionsheet
 */
public class ActionSheet extends CordovaPlugin {

	public ActionSheet() {
		super();
	}

	public boolean execute(String action, JSONArray args,
			CallbackContext callbackContext) throws JSONException {

		if ("show".equals(action)) {
			JSONObject options = args.optJSONObject(0);

			String title = options.optString("title");
			JSONArray buttons = options.optJSONArray("buttonLabels");
			String addCancelButtonWithLabel = options
					.optString("addCancelButtonWithLabel");
			String addDestructiveButtonWithLabel = options
					.optString("addDestructiveButtonWithLabel");

			this.show(title, buttons, addCancelButtonWithLabel,
					addDestructiveButtonWithLabel, callbackContext);
			// return true;
		} else {
			return false;
		}

		callbackContext.success();
		return true;
	}

	public synchronized void show(final String title,
			final JSONArray buttonLabels,
			final String addCancelButtonWithLabel,
			final String addDestructiveButtonWithLabel,
			final CallbackContext callbackContext) {

		final CordovaInterface cordova = this.cordova;

		Runnable runnable = new Runnable() {
			public void run() {
				AlertDialog.Builder builder = new AlertDialog.Builder(
						cordova.getActivity());
				builder.setTitle(title);

				builder.setCancelable(true);

				if (!TextUtils.isEmpty(addCancelButtonWithLabel)) {
					builder.setNegativeButton(addCancelButtonWithLabel,
							new OnClickListener() {
								@Override
								public void onClick(DialogInterface dialog,
										int which) {
									dialog.dismiss();
									callbackContext
											.sendPluginResult(new PluginResult(
													PluginResult.Status.OK, 0));
								}
							});
				}

				// XXX So what do we do with the iOS destructive button?
				// Android doesn't really have the concept, so we're going to
				// ignore it until we have a situation where we can come up with
				// a good way to implement it. Most likely adding an image
				// or some other indicator.

				// if (!TextUtils.isEmpty(addDestructiveButtonWithLabel)) {
				// builder.setNeutralButton(addDestructiveButtonWithLabel,
				// new OnClickListener() {
				// @Override
				// public void onClick(DialogInterface dialog,
				// int which) {
				// dialog.dismiss();
				// callbackContext
				// .sendPluginResult(new PluginResult(
				// PluginResult.Status.OK, 0));
				// }
				// });
				// }

				String[] buttons = getStringArray(buttonLabels);
				builder.setItems(buttons, new OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						dialog.dismiss();
						// java 0 based index converted to cordova 1 based
						// index, so we don't confuse the webbies.
						callbackContext.sendPluginResult(new PluginResult(
								PluginResult.Status.OK, which + 1));
					}
				});

				builder.setOnCancelListener(new AlertDialog.OnCancelListener() {
					public void onCancel(DialogInterface dialog) {
						dialog.dismiss();
						callbackContext.sendPluginResult(new PluginResult(
								PluginResult.Status.OK, 0));
					}
				});

				builder.create().show();
			};
		};
		this.cordova.getActivity().runOnUiThread(runnable);
	}

	private String[] getStringArray(JSONArray jsonArray) {
		String[] stringArray = null;
		int length = jsonArray.length();
		if (jsonArray != null) {
			stringArray = new String[length];
			for (int i = 0; i < length; i++) {
				stringArray[i] = jsonArray.optString(i);
			}
		}
		return stringArray;
	}

}
