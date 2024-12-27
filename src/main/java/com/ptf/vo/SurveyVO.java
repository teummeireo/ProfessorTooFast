
package com.ptf.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class SurveyVO {
	private int	surveyId;
	private int userId;
	private int statisticsId;
	private int difficulty;
	private int speed;
	private int material;
	private String questions;
	private String comments;
	private Date createAt;
}
