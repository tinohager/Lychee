<?php

use App\Models\Extensions\BaseConfigMigration;

return new class() extends BaseConfigMigration {
	public const GALLERY = 'Gallery';
	public const POSITIVE = 'positive';
	public const BOOL = 'bool';

	public function getConfigs(): array
	{
		return [
			[
				'key' => 'default_album_thumb_aspect_ratio',
				'value' => '1/1',
				'confidentiality' => '0',
				'cat' => self::GALLERY,
				'type_range' => '1/1|2/3|3/2|4/5|5/4|16/9',
				'description' => 'Default aspect ratio for album thumbs, one of: 1/1, 2/3, 3/2, 4/5, 5/4, 16/9',
			],
		];
	}
};
