
package com.ptf.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class StatisticsVO {
	private int statisticsId;
	private Date date;
	private float avgDifficulty;
	private float avgSpeed;
	private float avgMaterial;
	private int population; 
}
